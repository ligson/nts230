/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.width = '830'; // 宽度
	config.skin='v2';  
	//config.toolbarStartupExpanded = false;	//工具栏是否展开add by jlf
	config.shiftEnterMode = CKEDITOR.ENTER_P;//shift+enter实现换段  add by jlf
    config.enterMode = CKEDITOR.ENTER_BR;//enter实现换行 add by jlf
};
