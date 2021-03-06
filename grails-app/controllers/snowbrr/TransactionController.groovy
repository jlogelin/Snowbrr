package snowbrr

import grails.plugin.springsecurity.annotation.Secured
import grails.plugin.springsecurity.SpringSecurityUtils

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional


@Transactional(readOnly = true)
@Secured(['ROLE_CONSUMER', 'ROLE_PROVIDER', 'ROLE_ADMIN'])
class TransactionController {

    def springSecurityService

    def messageService

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)

        if( Provider.findByUser ( springSecurityService.currentUser ) ){
            Provider provider = Provider.findByUser ( springSecurityService.currentUser )
            def transactions = Transaction.findAllByProvider(provider)
            respond transactions.sort(), model: [transactionInstanceCount: transactions?.size()]
        }else if ( Consumer.findByUser ( springSecurityService.currentUser ) ){
            Consumer consumer = Consumer.findByUser ( springSecurityService.currentUser )
            def transactions = Transaction.findAllByConsumer(consumer)
            respond transactions.sort(), model: [transactionInstanceCount: transactions?.size()]
        } else {
            respond Transaction.list(params).sort(), model: [transactionInstanceCount: Transaction.count()]
        }
    }

    def active() {

        def transactions
        if( Provider.findByUser ( springSecurityService.currentUser ) ){
            Provider provider = Provider.findByUser ( springSecurityService.currentUser )
            transactions = Transaction.findAllByProvider(provider)
        }else if ( Consumer.findByUser ( springSecurityService.currentUser ) ){
            Consumer consumer = Consumer.findByUser ( springSecurityService.currentUser )
            transactions = Transaction.findAllByConsumer(consumer)
        }

        def s = transactions.findAll{
            boolean valid = !(it.status in ['Complete', 'Cancelled'])
            valid
        }.size()

        render s
    }

    def show(Transaction transactionInstance) {
        respond transactionInstance
    }

    @Secured('ROLE_CONSUMER')
    def create() {
        respond new Transaction(params)
    }

    private def mutateTransaction(Transaction transactionInstance) {

        if( Provider.findByUser ( springSecurityService.currentUser ) ){
            transactionInstance.provider = Provider.findByUser ( springSecurityService.currentUser )
        }else if ( Consumer.findByUser ( springSecurityService.currentUser ) ) {
            transactionInstance.consumer = Consumer.findByUser ( springSecurityService.currentUser )
        }
        transactionInstance
    }

    @Transactional
    def save(Transaction transactionInstance) {
        if (transactionInstance == null) {
            notFound()
            return
        }

        if (transactionInstance.hasErrors()) {
            respond transactionInstance.errors, view: 'create'
            return
        }

        mutateTransaction transactionInstance

        transactionInstance.save flush: true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'transaction.label', default: 'Transaction'), transactionInstance.id])
                redirect transactionInstance
            }
            '*' { respond transactionInstance, [status: CREATED] }
        }
    }

    def edit(Transaction transactionInstance) {
        respond transactionInstance
    }

    @Secured('ROLE_CONSUMER')
    def consumerRequest() {
        def providerId = params.providerId
        def provider = Provider.get(providerId)

        Transaction transactionInstance = new Transaction()
        transactionInstance.provider = provider
        transactionInstance.status = 'Request'
        transactionInstance.finishBy = new Date()
        transactionInstance.price = provider.initialPrice

        mutateTransaction transactionInstance
        transactionInstance.save flush: true

        messageService.send(User.findByUsername('admin'), transactionInstance.consumer.user, 'You have created a new transaction request with ' + transactionInstance.provider.companyName)
        messageService.send(User.findByUsername('admin'), transactionInstance.provider.user, "${transactionInstance.consumer.user.firstname} ${transactionInstance.consumer.user.lastname} would like to Request a new transaction with you.")

        flash.message = 'Transaction has been created and request sent to Provider'

        def targetUri = params.targetUri ?: "/"
        if(params.targetUri) {
            redirect(uri: targetUri)
        }else {
            redirect transactionInstance
        }
    }

    @Secured('ROLE_CONSUMER')
    def consumerCancel(Transaction transactionInstance) {

        if (transactionInstance == null) {
            notFound()
            return
        }

        if (transactionInstance.hasErrors()) {
            respond transactionInstance.errors, view: 'show'
            return
        }

        if(transactionInstance.status == 'Cancel' || transactionInstance.status == 'Complete') {
            flash.message = 'You cannot Cancel a transaction that is already Cancelled or Complete.'
            redirect transactionInstance
            return
        }

        transactionInstance.status = 'Cancelled'
        mutateTransaction transactionInstance
        transactionInstance.save flush: true

        messageService.send(User.findByUsername('admin'), transactionInstance.consumer.user, "You have cancelled request for snow removal with ${transactionInstance.provider.companyName}")
        messageService.send(User.findByUsername('admin'), transactionInstance.provider.user, "${transactionInstance.consumer.user.firstname} ${transactionInstance.consumer.user.lastname} has cancelled the transaction")

        flash.message = 'Transaction has been cancelled'
        redirect transactionInstance
    }

    @Secured('ROLE_PROVIDER')
    def providerAccept(Transaction transactionInstance) {

        if (transactionInstance == null) {
            notFound()
            return
        }

        if (transactionInstance.hasErrors()) {
            respond transactionInstance.errors, view: 'show'
            return
        }

        if(transactionInstance.status != 'Request') {
            flash.message = 'You cannot Accept a transaction that is not in the Request State.'
            redirect transactionInstance
            return
        }

        transactionInstance.status = 'In Progress'
        mutateTransaction transactionInstance
        transactionInstance.save flush: true

        messageService.send(User.findByUsername('admin'), transactionInstance.consumer.user, "${transactionInstance.provider.companyName} has accepted your transaction request")
        messageService.send(User.findByUsername('admin'), transactionInstance.provider.user, "You have accepted request for snow removal for ${transactionInstance.consumer.user.firstname} ${transactionInstance.consumer.user.lastname}")

        flash.message = 'Transaction has been accepted'
        redirect transactionInstance
    }

    @Secured('ROLE_PROVIDER')
    def providerCancel(Transaction transactionInstance) {

        if (transactionInstance == null) {
            notFound()
            return
        }

        if (transactionInstance.hasErrors()) {
            respond transactionInstance.errors, view: 'show'
            return
        }

        if(transactionInstance.status == 'Cancel' || transactionInstance.status == 'Complete') {
            flash.message = 'You cannot Cancel a transaction that is already Cancelled or Complete.'
            redirect transactionInstance
            return
        }

        transactionInstance.status = 'Cancelled'
        mutateTransaction transactionInstance
        transactionInstance.save flush: true

        messageService.send(User.findByUsername('admin'), transactionInstance.consumer.user, "${transactionInstance.provider.companyName} has cancelled your transaction request")
        messageService.send(User.findByUsername('admin'), transactionInstance.provider.user, "You have cancelled request for snow removal for ${transactionInstance.consumer.user.firstname} ${transactionInstance.consumer.user.lastname}")


        flash.message = 'Transaction has been accepted'
        redirect transactionInstance
    }

    @Secured('ROLE_PROVIDER')
    def providerComplete(Transaction transactionInstance) {

        if (transactionInstance == null) {
            notFound()
            return
        }

        if (transactionInstance.hasErrors()) {
            respond transactionInstance.errors, view: 'show'
            return
        }

        if(transactionInstance.status != 'In Progress') {
            flash.message = 'You cannot Complete a transaction that has not yet been Started.'
            redirect transactionInstance
            return
        }

        transactionInstance.status = 'Complete'
        mutateTransaction transactionInstance
        transactionInstance.save flush: true

        messageService.send(User.findByUsername('admin'), transactionInstance.consumer.user, "${transactionInstance.provider.companyName} has completed your transaction request. Don't forget to rate your experience with this provider.")
        messageService.send(User.findByUsername('admin'), transactionInstance.provider.user, "You have completed work for ${transactionInstance.consumer.user.firstname} ${transactionInstance.consumer.user.lastname}. Don't forget to rate your experience with this client.")


        flash.message = 'Transaction has been complete'
        redirect transactionInstance
    }

    @Transactional
    def update(Transaction transactionInstance) {
        if (transactionInstance == null) {
            notFound()
            return
        }

        if (transactionInstance.hasErrors()) {
            respond transactionInstance.errors, view: 'edit'
            return
        }

        mutateTransaction transactionInstance

        transactionInstance.save flush: true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'transaction.label', default: 'Transaction'), transactionInstance.id])
                redirect transactionInstance
            }
            '*' { respond transactionInstance, [status: OK] }
        }
    }

    @Secured('ROLE_ADMIN')
    @Transactional
    def delete(Transaction transactionInstance) {

        if (transactionInstance == null) {
            notFound()
            return
        }

        transactionInstance.delete flush: true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'transaction.label', default: 'Transaction'), transactionInstance.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NO_CONTENT }
        }
    }

    @Secured('ROLE_PROVIDER')
    def uploadImage(Transaction transactionInstance) {

        if (transactionInstance == null) {
            notFound()
            return
        }

        def f = request.getFile('photoProof')
        transactionInstance.photoProof = f.bytes
        transactionInstance.save flush:true
        flash.message = "Photo ( ${transactionInstance.photoProof.size()} bytes ) uploaded."
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'transaction.label', default: 'Person'), transactionInstance.id])
                redirect transactionInstance
            }
            '*'{ respond transactionInstance, [status: OK] }
        }
    }

    def proofImage(Transaction transactionInstance) {
        response.outputStream << transactionInstance.photoProof
        response.outputStream.flush()
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'transaction.label', default: 'Transaction'), params.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NOT_FOUND }
        }
    }
}
