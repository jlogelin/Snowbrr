
<%@ page import="snowbrr.Message" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title><g:message code="message.create" default="Create Message" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir: '')}"><g:message code="home" default="Home" /></a></span>
        </div>
        <div class="body">
            <h1><g:message code="message.create" default="Create Message" /></h1>

            <g:hasErrors bean="${messageInstance}">
            <div class="errors">
                <g:renderErrors bean="${messageInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr hidden class="prop">
                                <td valign="top" class="name">
                                    <label for="timestamp"><g:message code="message.timestamp" default="Timestamp" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: messageInstance, field: 'timestamp', 'errors')}">
                                    <g:datePicker name="timestamp" value="${messageInstance?.timestamp}"  />

                                </td>
                            </tr>
                        
                            <tr hidden class="prop">
                                <td valign="top" class="name">
                                    <label for="from"><g:message code="message.from" default="From" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: messageInstance, field: 'from', 'errors')}">
                                    <g:select name="from.id" from="${snowbrr.User.list()}" optionKey="id" value="${messageInstance?.from?.id}"  />

                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="user"><g:message code="message.user" default="To" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: messageInstance, field: 'user', 'errors')}">
                                    <g:select name="user.id" from="${snowbrr.User.list()}" optionKey="id" value="${messageInstance?.user?.id}"  />

                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="content"><g:message code="message.content" default="Content" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: messageInstance, field: 'content', 'errors')}">
                                    <g:textArea name="content" value="${fieldValue(bean: messageInstance, field: 'content')}" />

                                </td>
                            </tr>
                        
                            <tr hidden class="prop">
                                <td valign="top" class="name">
                                    <label for="read"><g:message code="message.read" default="Read" />:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: messageInstance, field: 'read', 'errors')}">
                                    <g:checkBox name="read" value="${messageInstance?.read}" />

                                </td>
                            </tr>
                        

                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'create', 'default': 'Create')}" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
