<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="facet" uri="http://www.jahia.org/tags/facetLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="uiComponents" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="acl" type="java.lang.String"--%>
<c:set var="anchorName" value="facet-${currentNode.identifier}"/>

<c:set var="boundComponent"
       value="${uiComponents:getBindedComponent(currentNode, renderContext, 'j:bindedComponent')}"/>
<jcr:nodeProperty var="facetListNodeType" node="${currentNode}" name="j:type" />
<c:if test="${not empty boundComponent}">
    <c:set var="facetParamVarName" value="N-${boundComponent.name}"/>
    <c:set var="facetTargetTypeName" value="N-type-${boundComponent.name}"/>
    <c:set var="activeFacetMapVarName" value="afm-${boundComponent.name}"/>
    <c:if test="${not empty param[facetParamVarName] and empty activeFacetsVars[facetParamVarName]}">
        <c:if test="${activeFacetsVars == null}">
            <jsp:useBean id="activeFacetsVars" class="java.util.HashMap" scope="request"/>
        </c:if>
        <c:set target="${activeFacetsVars}" property="${facetParamVarName}"
               value="${functions:decodeUrlParam(param[facetParamVarName])}"/>
        <c:set target="${activeFacetsVars}" property="${activeFacetMapVarName}"
               value="${facet:getAppliedFacetFilters(activeFacetsVars[facetParamVarName])}"/>
    </c:if>

    <%-- These maps are populated by facet:setupQueryAndMetadata tag --%>
    <jsp:useBean id="facetLabels" class="java.util.HashMap" scope="request"/>
    <jsp:useBean id="facetValueLabels" class="java.util.HashMap" scope="request"/>
    <jsp:useBean id="facetValueFormats" class="java.util.HashMap" scope="request"/>
    <jsp:useBean id="facetValueRenderers" class="java.util.HashMap" scope="request"/>
    <jsp:useBean id="facetValueNodeTypes" class="java.util.HashMap" scope="request"/>

    <template:option node="${boundComponent}" nodetype="${boundComponent.primaryNodeTypeName},jmix:list"
                     view="hidden.load">
        <template:param name="queryLoadAllUnsorted" value="true"/>
        <template:param name="facetListNodeType" value="${facetListNodeType}" />
    </template:option>

    <facet:setupQueryAndMetadata var="listQuery" boundComponent="${boundComponent}"
                                 existingQuery="${moduleMap.listQuery}"
                                 activeFacets="${activeFacetsVars[activeFacetMapVarName]}"/>
    <jcr:jqom var="result" qomBeanName="listQuery" scope="request"/>
    <div class="d-flex align-items-baseline facets-box flex-wrap">
        <a name="${anchorName}" id="${anchorName}" class="shift"></a>
        <c:if test="${not result.facetResultsEmpty or !empty activeFacetsVars[activeFacetMapVarName]}">


            <div class="pr-2 gris"><i class="fas fa-filter"></i> <fmt:message key="label.filterBy"/>:</div>
            <c:forEach items="${result.facetFields}" var="currentFacet">
                <%@include file="facetDisplay.jspf" %>
            </c:forEach>
            <c:forEach items="${result.facetDates}" var="currentFacet">
                <%@include file="facetDisplay.jspf" %>
            </c:forEach>
            <c:forEach items="${result.rangeFacets}" var="currentFacet">
                <%@include file="rangeFacetDisplay.jspf" %>
            </c:forEach>
            <%--
            <c:set var="currentFacetLabel" value=""/>
            <c:set var="mappedFacetLabel" value=""/>
            <c:forEach items="${result.facetQuery}" var="facetValue" varStatus="iterationStatus">
                <facet:facetLabel currentActiveFacet="${facetValue}" facetLabels="${facetLabels}" display="false"/>
                <c:if test="${iterationStatus.first or (mappedFacetLabel != currentFacetLabel and not empty mappedFacetLabel)}">
                    <c:set var="currentFacetLabel" value="${mappedFacetLabel}"/>

                    <div class="facetsList">
                    <h5>${mappedFacetLabel}</h5>
                </c:if>
                <c:if test="${not facet:isFacetValueApplied(facetValue, activeFacetsVars[activeFacetMapVarName])}">
                    <c:set var="facetDrillDownUrl"
                           value="${facet:getFacetDrillDownUrl(facetValue, activeFacetsVars[facetParamVarName])}"/>
                    <c:url var="facetUrl" value="${url.mainResource}">
                        <c:param name="${facetTargetTypeName}" value="${functions:encodeUrlParam(facetListNodeType)}" />
                        <c:param name="${facetParamVarName}" value="${functions:encodeUrlParam(facetDrillDownUrl)}"/>
                    </c:url>
                    <a href="${facetUrl}"><facet:facetValueLabel currentActiveFacetValue="${facetValue}" facetValueLabels="${facetValueLabels}"/></a> (${facetValue.value})
                </c:if>
            </c:forEach>
            --%>

            <%@include file="activeFacets.jspf" %>

        </c:if>
    </div>
    <c:if test="${editableModule}">
        <a data-toggle="collapse" href="#collapse${currentNode.identifier}" href="#" role="button" aria-expanded="false" aria-controls="collapseExample">
            <i class="fas fa-cogs"></i>
        </a>
        <div class="collapse" id="collapse${currentNode.identifier}">
            <div class="alert alert-info" role="alert">
                <c:forEach items="${jcr:getNodes(currentNode, 'jnt:facet')}" var="facet">
                    <template:module node="${facet}"/>
                </c:forEach>
                <template:module path="*"/>
            </div>
        </div>
    </c:if>
</c:if>
