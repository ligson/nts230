/**
 █▒▓▒░ The FlexPaper Project

 This file is part of FlexPaper.

 FlexPaper is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 3 of the License.

 FlexPaper is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with FlexPaper.  If not, see <http://www.gnu.org/licenses/>.

 For more information on FlexPaper please see the FlexPaper project
 home page: http://flexpaper.devaldi.com
 */

$(function () {
    /**
     * Handles the event of external links getting clicked in the document.
     *
     * @example onExternalLinkClicked("http://www.google.com")
     *
     * @param String link
     */
    jQuery('#boful_doc_player').bind('onExternalLinkClicked', function (e, link) {
        window.open(link, '_flexpaper_exturl');
    });

    /**
     * Recieves progress information about the document being loaded
     *
     * @example onProgress( 100,10000 );
     *
     * @param int loaded
     * @param int total
     */
    jQuery('#boful_doc_player').bind('onProgress', function (e, loadedBytes, totalBytes) {

    });

    /**
     * Handles the event of a document is in progress of loading
     *
     */
    jQuery('#boful_doc_player').bind('onDocumentLoading', function (e) {

    });

    /**
     * Handles the event of a document is in progress of loading
     *
     */
    jQuery('#boful_doc_player').bind('onPageLoading', function (e, pageNumber) {

    });

    /**
     * Receives messages about the current page being changed
     *
     * @example onCurrentPageChanged( 10 );
     *
     * @param int pagenum
     */
    jQuery('#document_player').bind('onCurrentPageChanged', function (e, pagenum) {
        if (!isAnonymous) {
            $.post(baseUrl + "program/recoderPosition", {time: pagenum, serialId: serialId}, function (data) {

            });
        }
        // if GANumber is supplied then lets track this as a Google Analytics event.
        if (jQuery(this).data('TrackingNumber')) {
            var _gaq = window._gaq || [];
            window._gaq = _gaq;
            var trackingDoc = jQuery(this).data('TrackingDocument');
            var pdfFileName = trackingDoc.substr(0, trackingDoc.indexOf(".pdf") + 4);

            _gaq.push(['_setAccount', jQuery(this).data('TrackingNumber')]);
            _gaq.push(['_trackEvent', 'PDF Documents', 'Page View', pdfFileName + ' - page ' + pagenum]);

            (function () {
                var ga = document.createElement('script');
                ga.type = 'text/javascript';
                ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0];
                s.parentNode.insertBefore(ga, s);
            })();
        }
    });

    /**
     * Receives messages about the document being loaded
     *
     * @example onDocumentLoaded( 20 );
     *
     * @param int totalPages
     */
    jQuery('#document_player').bind('onDocumentLoaded', function (e, totalPages) {
        getDocViewer("document_player").fitWidth();
    });

    /**
     * Receives messages about the page loaded
     *
     * @example onPageLoaded( 1 );
     *
     * @param int pageNumber
     */
    jQuery('#boful_doc_player').bind('onPageLoaded', function (e, pageNumber) {
        getDocViewer().fitWidth();
    });

    /**
     * Receives messages about the page loaded
     *
     * @example onErrorLoadingPage( 1 );
     *
     * @param int pageNumber
     */
    jQuery('#boful_doc_player').bind('onErrorLoadingPage', function (e, pageNumber) {

    });

    /**
     * Receives error messages when a document is not loading properly
     *
     * @example onDocumentLoadedError( "Network error" );
     *
     * @param String errorMessage
     */
    jQuery('#boful_doc_player').bind('onDocumentLoadedError', function (e, errMessage) {

    });

    /**
     * Receives error messages when a document has finished printed
     *
     * @example onDocumentPrinted();
     *
     */
    jQuery('#boful_doc_player').bind('onDocumentPrinted', function (e) {

    });
});