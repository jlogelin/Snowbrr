
<button type="button" class="btn btn-success" data-toggle="modal" id="provider-id-${providerInstance.id}" data-target="#model-${providerInstance.id}">Request</button>

<!-- Modal -->
<div class="modal fade" id="model-${providerInstance.id}" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Provider Request</h4>
            </div>
            <div class="modal-body">
                <p>Begin transaction with ${providerInstance.user.firstname} ${providerInstance.user.lastname} ( ${providerInstance.companyName} )
                 for <g:formatNumber number="${providerInstance.initialPrice}" format="\$ ###,###.##" />?</p>

            </div>
            <div class="modal-footer">

                <g:link elementId="request-${providerInstance.id}" class="btn btn-info" style="color:white;" controller="transaction" action="consumerRequest" params="[providerId: providerInstance.id, targetUri: (request.forwardURI - request.contextPath)]">
                    Request
                </g:link>

                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>

            </div>
        </div>

    </div>
</div>