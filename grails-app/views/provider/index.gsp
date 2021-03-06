
<%@ page import="snowbrr.Provider" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'provider.label', default: 'Provider')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>

		<script src="http://maps.googleapis.com/maps/api/js"></script>
		<script>
			function initialize() {

				// Specify features and elements to define styles.
				var styleArray = [
					{
						featureType: "all",
						stylers: [
							{ saturation: -80 }
						]
					},{
						featureType: "road.arterial",
						elementType: "geometry",
						stylers: [
							{ hue: "#00ffee" },
							{ saturation: 50 }
						]
					},{
						featureType: "poi.business",
						elementType: "labels",
						stylers: [
							{ visibility: "off" }
						]
					}
				];

				var mapProp = {
					center:new google.maps.LatLng(46.0773695,-64.7007454),
					zoom:15,
					styles: styleArray,
					mapTypeId:google.maps.MapTypeId.ROADMAP
				};
				var map = new google.maps.Map(document.getElementById("googleMap"),mapProp);

				var infowindow = new google.maps.InfoWindow({
					content: "loading..."
				});

				$.getJSON("${g.createLink(controller:'provider',action:'list')}", function(data){
					for (var i = 0, len = data.length; i < len; i++) {

						var providerInfo = data[i];

						var contentString = '<div id="content">'+
								'<div id="siteNotice">'+
								'</div>'+
								'<h1 id="firstHeading" class="firstHeading"><a href="${g.createLink(controller:'provider',action:'show')}/' + providerInfo.id + '" >' +
								'<b>' + providerInfo.companyName + '</b> </a> </h1>' +
								'<div id="bodyContent">'+
								'<p><a href="${g.createLink(controller:'provider',action:'show')}/' + providerInfo.id + '" >' +
								'<b>' + providerInfo.firstname + ' ' +providerInfo.lastname + '</b> </a></p>'+
								'<p>' + providerInfo.address + '</p>'+
								'<p>phone: <a href="tel:' + providerInfo.phone + '"> ' + providerInfo.phone + ' </a></p>'+

								'</div>'+
								'</div>';

						var marker = new google.maps.Marker({
							position: new google.maps.LatLng(providerInfo.latitude, providerInfo.longitude),
							icon: '${assetPath(src: 'tractor.png')}',
							title: providerInfo.companyName,
							html: contentString
						});

						google.maps.event.addListener(marker, 'click', function () {
							infowindow.setContent(this.html);
							infowindow.open(map, this);
						});

						marker.setMap(map);
					}
				});

			}
			google.maps.event.addDomListener(window, 'load', initialize);
		</script>

	</head>
<body>

		<div id="googleMap" style="width:100%;height:500px;"></div>

		<div id="list-provider" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>

			<table class="table table-striped">
			<thead>
					<tr>
					
						<th><g:message code="provider.user.label" default="Username" /></th>

						<th><g:message code="provider.name.label" default="Contact Name" /></th>

						<th><g:message code="provider.address.label" default="Address" /></th>

						<th><g:message code="provider.phone.label" default="Phone" /></th>

						<g:sortableColumn property="companyName" title="${message(code: 'provider.companyName.label', default: 'Company Name')}" />

						<g:sortableColumn property="active" title="${message(code: 'provider.active.label', default: 'Active')}" />

						<th></th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${providerInstanceList}" status="i" var="providerInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${providerInstance.id}">${providerInstance.user.username}</g:link></td>

						<td>${providerInstance.user.firstname} ${providerInstance.user.lastname}</td>

						<td>${providerInstance.user.address}</td>

						<td> <a href="tel:${providerInstance.user.phone}">${providerInstance.user.phone}</a> </td>

						<td>${fieldValue(bean: providerInstance, field: "companyName")}</td>
					
						<td><g:formatBoolean boolean="${providerInstance.active}" /></td>

						<sec:ifAllGranted roles="ROLE_CONSUMER">
						<td>
							<g:render template="providerRequestDialog" model="[providerInstance: providerInstance]" />
						</td>
						</sec:ifAllGranted>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${providerInstanceCount ?: 0}" />
			</div>



		</div>
	</body>
</html>
