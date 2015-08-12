$(document).ready(function(){
	
	context.init({preventDoubleContext: false});
    context.attach('#categoryDiv', [
        /*	{header: 'Compressed Menu'}, */
        {text: '打开', href: '#',id:'openDiv()'},
        {divider: true},
        {text: '重命名', href: '#',id:'rename()'},
        {text: '删除', href: '#', id: 'deleteDel()'}
    ]);
	/*context.attach('#userFileDiv', [
		{header: 'Compressed Menu'}, *//*
		{text: '打开', href: '#',id:'openDiv()'},
		{text: '下载', href: '#',id:'downloadFile()'},
        {text: '修改', href: '#',id:'executeUpdate()'},
        {text: '增加标签', href: '#',id:'addTag()'},
        {text: '查看详情', href: '#', id: 'showUserFile()'},
        {divider: true},
        *//*{text: '制作专辑', href: '#',id:'createSpecial()'},*//*
        {text: '重命名', href: '#', id: 'rename()'},
		{text: '删除', href: '#',id:'deleteDel()'},
        {text: '权限设置', href: '#',id:'roleSet()'},
		{divider: true},
		{text: '共享', href: '#',id:"sharingFile('true')"},
		*//*{text: '不公开', href: '#',id:"sharingFile('false')"},*//*
        {text: '移动',href:'#',id:'moveFile()'}
	]);*/
    context.attach('#loadingDiv', [
        /*	{header: 'Compressed Menu'}, */
        {text: '打开', href: '#',id:'openDiv()'},
        {text: '下载', href: '#',id:'downloadFile()'},
        {text: '修改', href: '#',id:'executeUpdate()'},
        {text: '增加标签', href: '#',id:'addTag()'},
        {text: '查看详情', href: '#', id: 'showUserFile()'},
        {divider: true},
        /*{text: '制作专辑', href: '#',id:'createSpecial()'},*/
        {text: '重命名', href: '#', id: 'rename()'},
        {text: '删除', href: '#',id:'deleteDel()'},
        {text: '权限设置', href: '#',id:'roleSet()'},
        {divider: true},
        {text: '共享', href: '#',id:"sharingFile('true')"},
        {text: '取消共享', href: '#',id:"sharingFile('false')"},
        {text: '移动',href:'#',id:'moveFile()'}
    ]);
    context.attach('#recycleCateDiv', [
        /*	{header: 'Compressed Menu'}, */
        {text: '删除', href: '#',id:'deleteDel()'},
        {text: '还原', href: '#',id:'resetDel()'}
    ]);
    context.attach('#recycleFileDiv', [
        /*	{header: 'Compressed Menu'}, */
        {text: '删除', href: '#',id:'deleteDel()'},
        {text: '还原', href: '#',id:'resetDel()'}
    ]);

	
	$(document).on('mouseover', '.me-codesta', function(){
		$('.finale h1:first').css({opacity:0});
		$('.finale h1:last').css({opacity:1});
	});

	$(document).on('mouseout', '.me-codesta', function(){
		$('.finale h1:last').css({opacity:0});
		$('.finale h1:first').css({opacity:1});
	});




});