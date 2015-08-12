
function flexpaperInit(div, fileUrl, baseUrl){
    $('#'+div).FlexPaperViewer(
        { config: {
            SWFFile: fileUrl,
            ZoomTransition: 'easeOut',
            ZoomTime: 1.0,
            ZoomInterval: 0.2,
            FitPageOnLoad: true,
            FitWidthOnLoad: true,
            FullScreenAsMaxWindow: false,
            ProgressiveLoading: true,
            MinZoomSize: 0.2,
            MaxZoomSize: 5,
            SearchMatchAll: false,
            InitViewMode: 'Portrait',
            RenderingOrder: 'flash',
            ViewModeToolsVisible: true,
            ZoomToolsVisible: true,
            NavToolsVisible: true,
            CursorToolsVisible: true,
            SearchToolsVisible: true,
            WMode: 'opaque',
            localeChain: 'zh_CN',
            jsDirectory: baseUrl + 'js/flexPaper_2.1.9/js/'
        }
    });
}
