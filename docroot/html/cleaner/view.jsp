<%@ include file="/html/init.jsp" %>

<liferay-ui:error key="permission-error" message="Sie verf�gen nicht �ber die notwendigen Berechtigungen f�r diese Aktion"/>
<liferay-ui:success key="cleaner-success" message="Das Aufr�umen verlief erfolgreich" />

Dieses Tool dient dazu, einen �berblick �ber die im Portal enthaltenen Dokumente inkl Versionen zu erhalten sowie ggf. diese Fileversionen aufzur�umen. <br/><br /> 

Files gesamt: <%= DLFileEntryLocalServiceUtil.getDLFileEntriesCount() %><br/>
Versionen gesamt: <%= DLFileVersionLocalServiceUtil.getDLFileVersionsCount() %><br/>

<%
/** Liste aller Files **/
List<DLFileEntry> files = DLFileEntryLocalServiceUtil.getDLFileEntries(0, DLFileEntryLocalServiceUtil.getDLFileEntriesCount());
long size=0;
/** Gr��e aller Fileversions **/
for(DLFileEntry file:files) {
	List<DLFileVersion> versions = DLFileVersionLocalServiceUtil.getFileVersions(file.getFileEntryId(), 0);
	for(DLFileVersion ver : versions) {
		size+=ver.getSize();
	}
}
/** Umrechnung der Fileversiongesamtgr��e in KB, MB bzw GB **/
long sizeP = 0;
String sizeS = "Bytes";
if(size>1024) {
	if(size>(1024*1024)) {
		if(size>(1024*1024*1024)) {
			sizeP=size/(1024*1024*1024);
			sizeS="GB";
		} else {
			sizeP=size/(1024*1024);
			sizeS="MB";
		}
	}
	else {
		sizeP=size/1024;
		sizeS="KB";
	}
}
%>
Gesamtgr��e: ca. <%= sizeP %> <%= sizeS %><br/>
<%

/** aktuelle URL als redirectURL **/
PortletURL viewURL = renderResponse.createRenderURL();
viewURL.setWindowState(LiferayWindowState.NORMAL);

/** actionURL zum Antriggern der cleanVersions Methode **/
PortletURL actionURL = renderResponse.createActionURL();
actionURL.setParameter(ActionRequest.ACTION_NAME, "cleanVersions");
actionURL.setParameter("redirectURL", viewURL.toString());

%>


<c:if test='<%= themeDisplay.getPermissionChecker().isOmniadmin()||themeDisplay.getPermissionChecker().isCompanyAdmin() %>'>
<br/><br/>
	<aui:form action="<%= actionURL %>" method="POST" name="fm">
		<aui:select name="noRest" label="Anzahl zu belassener Versionen: ">
			<aui:option value="3">3</aui:option>
			<aui:option value="5" selected="true">5</aui:option>
			<aui:option value="10">10</aui:option>
		</aui:select>
		<aui:button type="submit" />
	</aui:form>

</c:if>
