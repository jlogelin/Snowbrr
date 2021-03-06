<%@ page import="snowbrr.User" %>
<%@ page import="snowbrr.Provider" %>
<%@ page import="snowbrr.Consumer" %>

<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><g:layoutTitle default="Grails"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="${assetPath(src: 'favicon.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" href="${assetPath(src: 'apple-touch-icon.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${assetPath(src: 'apple-touch-icon-retina.png')}">
		<asset:javascript src="application.js"/>

		<!-- Boostrap -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
		<asset:stylesheet src="responsive.css" />
		<asset:stylesheet src="main.css" />
		<g:layoutHead/>

		<sec:ifLoggedIn>
		<script>
			$( document ).ready(function() {

				function update() {
					$.getJSON("${g.createLink(controller:'message',action:'unread')}", function(data){
						if( data <= 0 ){
							$('#unread').hide()
						}else {
							$('#unread').show()
							$('#unread').text(data);
						}
					});

					$.getJSON("${g.createLink(controller:'transaction',action:'active')}", function(data){
						if( data <= 0 ){
							$('#trans').hide()
						}else {
							$('#trans').show()
							$('#trans').text(data);
						}
					});

				}

				update();

				setInterval(update, 5000);
			});
		</script>
		</sec:ifLoggedIn>

	</head>
	<body>
	<!-- responsive navbar -->
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="/Snowbrr">SnowBrr</a>
			</div>

			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
					<li ${controllerName == 'provider' && actionName == 'index' ? 'class=active' : ''}>
						<g:link controller="provider" action="index">
							<span class="glyphicon glyphicon-road" aria-hidden="true"></span>
							Providers
						</g:link>
					</li>
					<li ${controllerName == 'transaction' && actionName == 'index' ? 'class=active' : ''}>
						<g:link controller="transaction" action="index">
							<span class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>
							Transactions
							<span id="trans" class="badge"></span>
						</g:link>
					</li>
					<li ${controllerName == 'message' && actionName == 'index' ? 'class=active' : ''}>
						<g:link controller="message" action="index">
							<span class="glyphicon glyphicon-envelope" aria-hidden="true"></span>
							Messages
							<span id="unread" class="badge"></span>
						</g:link>
					</li>

					<sec:ifAllGranted roles="ROLE_PROVIDER">
						<li ${controllerName == 'consumer' && actionName == 'index' ? 'class=active' : ''}>
							<g:link controller="consumer" action="index">
								<span class="glyphicon glyphicon-heart-empty" aria-hidden="true"></span>
								Customers
								<span id="unread" class="badge"></span>
							</g:link>
						</li>
 					</sec:ifAllGranted>

				</ul>
				<ul class="nav navbar-nav navbar-right">
					<sec:ifNotLoggedIn>
						<li> <g:link controller="login" action="auth">Login</g:link>  </li>
					</sec:ifNotLoggedIn>
					<sec:ifLoggedIn>

						<li>
							<sec:ifAllGranted roles="ROLE_PROVIDER">
								<g:link controller="provider" action="show" id="${Provider.findByUser ( User.findByUsername( sec.username() ) ).id}">
									<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
									Hello, <sec:username/>!
									<span class="label label-primary">Provider</span>
								</g:link>

							</sec:ifAllGranted>
							<sec:ifAllGranted roles="ROLE_CONSUMER">
								<g:link controller="consumer" action="show" id="${Consumer.findByUser ( User.findByUsername( sec.username() ) ).id}">
									<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
									Hello, <sec:username/>!
									<span class="label label-default">
										Customer
									</span>
								</g:link>
							</sec:ifAllGranted>

							</a>
						</li>
						<li>

						<g:remoteLink elementId="logout" class="logout" controller="logout" method="post" asynchronous="false" onComplete="location.reload()" onSuccess="location.reload()">Logout</g:remoteLink>


					</sec:ifLoggedIn>
				</ul>
			</div>
		</div>
	</nav>

	<div class="container">
			<g:if test="${flash.message}">
				<div class="alert alert-info alert-dismissible" role="alert">
					<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
					<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					${flash.message}
				</div>
			</g:if>

			<g:layoutBody/>
			<div class="footer" role="contentinfo"></div>
			<div id="spinner" class="spinner" style="display:none;"><g:message code="spinner.alt" default="Loading&hellip;"/></div>
		</div>
	</body>
</html>
