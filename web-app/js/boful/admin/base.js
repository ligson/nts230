window.loaded=true;
function gen_unique(){return++gen_unique._counter;}
gen_unique._counter=0;function ge(id){if(typeof(id)=='undefined'){Util.error('Tried to get an undefined element!');return null;}
var obj;if(typeof(id)=='string'){obj=document.getElementById(id);if(!(ua.ie()>=7)){return obj;}
if(!obj){return null;}else if(typeof(obj.id)=='string'&&obj.id==id){return obj;}else{var candidates=document.getElementsByName(id);if(!candidates||!candidates.length){return null;}
var maybe=[];for(var ii=0;ii<candidates.length;ii++){var c=candidates[ii];if(!c.id&&id){continue;}
if(typeof(c.id)=='string'&&c.id!=id){continue;}
maybe.push(candidates[ii]);}
if(maybe.length!=1){Util.error('ge() failed in a bizarre complicated edge case. Check comments.');return null;}
return maybe[0];}}else{return id;}
return null;}
function $(){var el=ge.apply(null,arguments);if(!el){Util.warn('Tried to get element %q, but it is not present in the page. (Use ge() '+'to test for the presence of an element.)',arguments[0]);}
return el;}
function show(){for(var i=0;i<arguments.length;i++){var element=ge(arguments[i]);if(element&&element.style)element.style.display='';}
return false;}
function hide(){for(var i=0;i<arguments.length;i++){var element=ge(arguments[i]);if(element&&element.style)element.style.display='none';}
return false;}
function shown(el){el=ge(el);return(el.style.display!='none');}
function toggle(){for(var i=0;i<arguments.length;i++){var element=$(arguments[i]);element.style.display=get_style(element,"display")=='block'?'none':'block';}
return false;}
function is_descendent(base_obj,target_id){var target_obj=ge(target_id);if(base_obj==null)return;while(base_obj!=target_obj){if(base_obj.parentNode){base_obj=base_obj.parentNode;}else{return false;}}
return true;}
function get_style(object,prop){function hyphenate(prop){return prop.replace(/[A-Z]/g,function(match){return'-'+match.toLowerCase();});}
if(window.getComputedStyle){return window.getComputedStyle(object,null).getPropertyValue(hyphenate(prop));}
if(document.defaultView&&document.defaultView.getComputedStyle){var computedStyle=document.defaultView.getComputedStyle(object,null);if(computedStyle)
return computedStyle.getPropertyValue(hyphenate(prop));if(prop=="display")
return"none";Util.error("Can't retrieve requested style %q due to a bug in Safari",prop);}
if(object.currentStyle){return object.currentStyle[prop];}
return object.style[prop];}
function close_more_list(){var list_expander=ge('expandable_more');if(list_expander){list_expander.style.display='none';removeEventBase(document,'click',list_expander.offclick,list_expander.id);}
var sponsor=ge('ssponsor');if(sponsor){sponsor.style.position='';}
var link_obj=ge('more_link');if(link_obj){link_obj.innerHTML='更多';link_obj.className='expand_link more_apps';}}
function expand_more_list(){var list_expander=ge('expandable_more');var more_link=ge('more_section');if(more_link){remove_css_class_name(more_link,'highlight_more_link');}
if(list_expander){list_expander.style.display='block';list_expander.offclick=function(e){if(!is_descendent(event_get_target(e),'sidebar_content')){close_more_list();}}.bind(list_expander);addEventBase(document,'click',list_expander.offclick,list_expander.id);}
var sponsor=ge('ssponsor');if(sponsor){sponsor.style.position='static';}
var link_obj=ge('more_link');if(link_obj){link_obj.innerHTML='隐藏';link_obj.className='expand_link less_apps';}}
function toggle_more_list(){var list_expander=ge('expandable_more');if(!list_expander){return false;}
if(list_expander.style.display=='none'){expand_more_list();}else{close_more_list();}}
function remove_node(node)
{if(node.removeNode)
node.removeNode(true);else{for(var i=node.childNodes.length-1;i>=0;i--)
remove_node(node.childNodes[i]);node.parentNode.removeChild(node);}
return null;}
function create_hidden_input(name,value){var new_input=document.createElement('input');new_input.name=name;new_input.id=name;new_input.value=value;new_input.type='hidden';return new_input;}
function has_css_class_name(elem,cname){return(elem&&cname)?new RegExp('\\b'+trim(cname)+'\\b').test(elem.className):false;}
function swap_css_class_name(elements,class1,class2){for(var i=0;i<elements.length;i++){var element=ge(elements[i]);if(element.className.indexOf(class1)!=-1){element.className=element.className.replace(class1,class2);}else{element.className=element.className.replace(class2,class1);}}}
function add_css_class_name(elem,cname){if(elem&&cname){if(elem.className){if(has_css_class_name(elem,cname)){return false;}else{elem.className+=' '+trim(cname);return true;}}else{elem.className=cname;return true;}}else{return false;}}
function remove_css_class_name(elem,cname){if(elem&&cname&&elem.className){cname=trim(cname);var old=elem.className;elem.className=elem.className.replace(new RegExp('\\b'+cname+'\\b'),'');return elem.className!=old;}else{return false;}}
function toggle_css_class_name(elem,cname){if(has_css_class_name(elem,cname)){remove_css_class_name(elem,cname);}else{add_css_class_name(elem,cname);}}
function set_inner_html(obj,html){var dummy='<span style="display:none">&nbsp</span>';html=html.replace('<style',dummy+'<style');html=html.replace('<STYLE',dummy+'<STYLE');html=html.replace('<script',dummy+'<script');html=html.replace('<SCRIPT',dummy+'<SCRIPT');obj.innerHTML=html;eval_inner_js(obj);addSafariLabelSupport(obj);}
function eval_inner_js(obj){var scripts=obj.getElementsByTagName('script');for(var i=0;i<scripts.length;i++){if(scripts[i].src){var script=document.createElement('script');script.type='text/javascript';script.src=scripts[i].src;document.body.appendChild(script);}else{try{eval_global(scripts[i].innerHTML);}catch(e){if(typeof console!='undefined'){console.error(e);}}}}}
function eval_global(js){var obj=document.createElement('script');obj.type='text/javascript';try{obj.innerHTML=js;}catch(e){obj.text=js;}
document.body.appendChild(obj);}
var KEYS={BACKSPACE:8,TAB:9,RETURN:13,ESC:27,SPACE:32,LEFT:37,UP:38,RIGHT:39,DOWN:40,DELETE:46};var KeyCodes={Left:63234,Right:63235};function mouseX(event)
{return event.pageX||(event.clientX+
(document.documentElement.scrollLeft||document.body.scrollLeft));}
function mouseY(event)
{return event.pageY||(event.clientY+
(document.documentElement.scrollTop||document.body.scrollTop));}
function pageScrollX()
{return document.body.scrollLeft||document.documentElement.scrollLeft;}
function pageScrollY()
{return document.body.scrollTop||document.documentElement.scrollTop;}
function elementX(obj){var left=obj.offsetLeft;var op=obj.offsetParent;while(obj.parentNode&&document.body!=obj.parentNode){obj=obj.parentNode;left-=obj.scrollLeft;if(op==obj){if(ua.safari()<500&&obj.tagName=='TR'){left+=obj.firstChild.offsetLeft;}else{left+=obj.offsetLeft;}
op=obj.offsetParent;}}
return left;}
function elementY(obj){var top=obj.offsetTop;var op=obj.offsetParent;while(obj.parentNode&&document.body!=obj.parentNode){obj=obj.parentNode;top-=obj.scrollTop;if(op==obj){if(ua.safari()<500&&obj.tagName=='TR'){top+=obj.firstChild.offsetTop;}else{top+=obj.offsetTop;}
op=obj.offsetParent;}}
return top;}
function warn_if_unsaved(form_id){onloadRegister(function(){var form_state=[];var form=ge(form_id);var inputs=get_all_form_inputs();for(var i=0;i<inputs.length;++i){if(is_button(inputs[i])){inputs[i].onclick=bind(null,function(old,e){dont_warn_if_unsaved();return old&&old(e);},inputs[i].onclick);}else if(is_descendent(inputs[i],form)){form_state.push({'element':inputs[i],'value':inputs[i].value});}}
(function(original_form_state){onbeforeunloadRegister(function(){if(!document.unsaved_warning_disabled){for(var i=0;i<original_form_state.length;++i){var input_element=original_form_state[i].element;var original_value=original_form_state[i].value;if(input_element.value!=original_value){return'You have unsaved changes.  Continue?'}}}});})(form_state);});}
function dont_warn_if_unsaved(){document.unsaved_warning_disabled=true;}
function get_all_form_inputs(root_element){var FORM_INPUT_TAG_NAMES={'input':1,'select':1,'textarea':1,'button':1};root_element=root_element||document;var ret=[];for(var tag_name in FORM_INPUT_TAG_NAMES){var elements=root_element.getElementsByTagName(tag_name);for(var i=0;i<elements.length;++i){ret.push(elements[i]);}}
return ret;}
function serialize_form_helper(data,name,value){var match=/([^\]]+)\[([^\]]*)\](.*)/.exec(name);if(match){data[match[1]]=data[match[1]]||{};if(match[2]==''){var i=0;while(data[match[1]][i]!=undefined){i++;}}else{i=match[2];}
if(match[3]==''){data[match[1]][i]=value;}else{serialize_form_helper(data[match[1]],i.concat(match[3]),value);}}else{data[name]=value;}}
function serialize_form(obj){var data={};var elements=obj.tagName=='FORM'?obj.elements:get_all_form_inputs(obj);for(var i=elements.length-1;i>=0;i--){if(elements[i].name&&!elements[i].disabled){if(!(elements[i].type=='radio'||elements[i].type=='checkbox')||elements[i].checked||(!elements[i].type||elements[i].type=='text'||elements[i].type=='password'||elements[i].type=='hidden'||elements[i].tagName=='TEXTAREA'||elements[i].tagName=='SELECT')){serialize_form_helper(data,elements[i].name,elements[i].value);}}}
return data;}
function is_button(element){var tagName=element.tagName.toUpperCase();if(tagName=='BUTTON'){return true;}
if(tagName=='INPUT'&&element.type){var type=element.type.toUpperCase();return type=='BUTTON'||type=='SUBMIT';}
return false;}
function addEventBase(obj,type,fn,name_hash)
{if(obj.addEventListener)
obj.addEventListener(type,fn,false);else if(obj.attachEvent)
{obj["e"+type+fn+name_hash]=fn;obj[type+fn+name_hash]=function(){obj["e"+type+fn+name_hash](window.event);}
obj.attachEvent("on"+type,obj[type+fn+name_hash]);}}
function removeEventBase(obj,type,fn,name_hash)
{if(obj.removeEventListener)
obj.removeEventListener(type,fn,false);else if(obj.detachEvent)
{obj.detachEvent("on"+type,obj[type+fn+name_hash]);obj[type+fn+name_hash]=null;obj["e"+type+fn+name_hash]=null;}}
function placeholderSetup(id){var el=ge(id);if(!el)return;if(el.type=='search')return;var ph=el.getAttribute("placeholder");if(!ph||ph=="")
return;if(el.value==ph)
el.value="";el.is_focused=(el.value!="");if(!el.is_focused){el.value=ph;el.style.color='#777';el.is_focused=0;}
addEventBase(el,'focus',placeholderFocus);addEventBase(el,'blur',placeholderBlur);}
function placeholderFocus(){if(!this.is_focused){this.is_focused=1;this.value='';this.style.color='#000';var rs=this.getAttribute("radioselect");if(rs&&rs!=""){var re=document.getElementById(rs);if(!re){return;}
if(re.type!='radio')return;re.checked=true;}}}
function placeholderBlur(){var ph=this.getAttribute("placeholder")
if(this.is_focused&&ph&&this.value==""){this.is_focused=0;this.value=ph;this.style.color='#777';}}
function optional_drop_down_menu(arrow,link,menu,event,arrow_class,arrow_old_class)
{if(menu.style.display=='none'){menu.style.display='block';var old_arrow_classname=arrow_old_class?arrow_old_class:arrow.className;if(link){link.className='active';}
arrow.className=arrow_class?arrow_class:'global_menu_arrow_active';var justChanged=true;var shim=ge(menu.id+'_iframe');if(shim){shim.style.top=menu.style.top;shim.style.right=menu.style.right;shim.style.display='block';shim.style.width=(menu.offsetWidth+2)+'px';shim.style.height=(menu.offsetHeight+2)+'px';}
menu.offclick=function(e){if(!justChanged){hide(this);if(link){link.className='';}
arrow.className=old_arrow_classname;var shim=ge(menu.id+'_iframe');if(shim){shim.style.display='none';shim.style.width=menu.offsetWidth+'px';shim.style.height=menu.offsetHeight+'px';}
removeEventBase(document,'click',this.offclick,menu.id);}else{justChanged=false;}}.bind(menu);addEventBase(document,'click',menu.offclick,menu.id);}
return false;}
function position_app_switcher(){var switcher=ge('app_switcher');var menu=ge('app_switcher_menu');menu.style.top=(switcher.offsetHeight-1)+'px';menu.style.right='0px';}
function addSafariLabelSupport(base){if(ua.safari()<500){var labels=(base||document.body).getElementsByTagName("label");for(i=0;i<labels.length;i++){labels[i].addEventListener('click',addLabelAction,true);}}}
function addLabelAction(event){var id=this.getAttribute('for');var item=null;if(id){item=document.getElementById(id);}else{item=this.getElementsByTagName('input')[0];}
if(!item||event.srcElement==item){return;}
if(item.type=='checkbox'){item.checked=!item.checked;}else if(item.type=='radio'){var radios=document.getElementsByTagName('input');for(i=0;i<radios.length;i++){if(radios[i].name==item.name&&radios[i].form==item.form){radios.checked=false;}}
item.checked=true;}else{item.focus();}
if(item.onclick){item.onclick(event);}}
function escapeURI(u)
{if(encodeURIComponent){return encodeURIComponent(u);}
if(escape){return escape(u);}}
function goURI(href){window.location.href=href;}
function is_email(email){return/^[\w!.%+]+@[\w]+(?:\.[\w]+)+$/.test(email);}
function getViewportWidth(){var width=0;if(document.documentElement&&document.documentElement.clientWidth){width=document.documentElement.clientWidth;}
else if(document.body&&document.body.clientWidth){width=document.body.clientWidth;}
else if(window.innerWidth){width=window.innerWidth-18;}
return width;};function getViewportHeight(){var height=0;if(window.innerHeight){height=window.innerHeight-18;}
else if(document.documentElement&&document.documentElement.clientHeight){height=document.documentElement.clientHeight;}
else if(document.body&&document.body.clientHeight){height=document.body.clientHeight;}
return height;};function getPageScrollHeight(){var height;if(typeof(window.pageYOffset)=='number'){height=window.pageYOffset;}else if(document.body&&document.body.scrollTop){height=document.body.scrollTop;}else if(document.documentElement&&document.documentElement.scrollTop){height=document.documentElement.scrollTop;}
if(isNaN(height))return 0;return height;};function getRadioFormValue(obj){for(i=0;i<obj.length;i++){if(obj[i].checked){return obj[i].value;}}
return null;}
function getTableRowShownDisplayProperty(){if(ua.ie()){return'inline';}else{return'table-row';}}
function showTableRow()
{for(var i=0;i<arguments.length;i++){var element=ge(arguments[i]);if(element&&element.style)element.style.display=getTableRowShownDisplayProperty();}
return false;}
function getParentRow(el){el=ge(el);while(el.tagName&&el.tagName!="TR"){el=el.parentNode;}
return el;}
function stopPropagation(e){if(!e)var e=window.event;e.cancelBubble=true;if(e.stopPropagation){e.stopPropagation();}}
function show_standard_status(status){s=ge('standard_status');if(s){var header=s.firstChild;header.innerHTML=status;show('standard_status');}}
function hide_standard_status(){s=ge('standard_status');if(s){hide('standard_status');}}
function remove_node(node){if(node.removeNode)
node.removeNode(true);else{for(var i=node.childNodes.length-1;i>=0;i--)
remove_node(node.childNodes[i]);node.parentNode.removeChild(node);}
return null;}
function adjustImage(obj,stop_word,max){var pn=obj.parentNode;if(stop_word==null)
stop_word='note_content';if(max==null){while(pn.className.indexOf(stop_word)==-1)
pn=pn.parentNode;if(pn.offsetWidth)
max=pn.offsetWidth;else
max=400;}
if(navigator.userAgent.indexOf('AppleWebKit/4')==-1){obj.style.position='absolute';obj.style.left=obj.style.top='-32000px';}
obj.className=obj.className.replace('img_loading','img_ready');if(obj.width>max){if(window.ActiveXObject){try{var img_div=document.createElement('div');img_div.style.filter='progid:DXImageTransform.Microsoft.AlphaImageLoader(src="'+obj.src.replace('"','%22')+'", sizingMethod="scale")';img_div.style.width=max+'px';img_div.style.height=((max/obj.width)*obj.height)+'px';if(obj.parentNode.tagName=='A')
img_div.style.cursor='pointer';obj.parentNode.insertBefore(img_div,obj);obj.removeNode(true);}
catch(e){obj.style.width=max+'px';}}
else
obj.style.width=max+'px';}
obj.style.left=obj.style.top=obj.style.position='';}
function imageConstrainSize(src,maxX,maxY,placeholderid){var image=new Image();image.onload=function(){if(image.width>0&&image.height>0){var width=image.width;var height=image.height;if(width>maxX||height>maxY){var desired_ratio=maxY/maxX;var actual_ratio=height/width;if(actual_ratio>desired_ratio){width=width*(maxY/height);height=maxY;}else{height=height*(maxX/width);width=maxX;}}
var placeholder=ge(placeholderid);var newimage=document.createElement('img');newimage.src=src;newimage.width=width;newimage.height=height;placeholder.parentNode.insertBefore(newimage,placeholder);placeholder.parentNode.removeChild(placeholder);}}
image.src=src;}
function set_opacity(obj,opacity){try{obj.style.opacity=(opacity==1?'':opacity);obj.style.filter=(opacity==1?'':'alpha(opacity='+opacity*100+')');}
catch(e){}}
function get_opacity(obj){var opacity=get_style(obj,'filter');var val=null;if(opacity&&(val=/(\d+(?:\.\d+)?)/.exec(opacity))){return parseFloat(val.pop())/100;}else if(opacity=get_style(obj,'opacity')){return parseFloat(opacity);}else{return 1;}}
function get_caret_position(obj){obj.focus();if(document.selection){if(obj.tagName=='INPUT'){var range=document.selection.createRange();return{start:-range.moveStart('character',-obj.value.length),end:-range.moveEnd('character',-obj.value.length)};}else if(obj.tagName=='TEXTAREA'){var range=document.selection.createRange();var range2=range.duplicate();range2.moveToElementText(obj);range2.setEndPoint('StartToEnd',range);var end=obj.value.length-range2.text.length;range2.setEndPoint('StartToStart',range);return{start:obj.value.length-range2.text.length,end:end};}else{return{start:undefined,end:undefined};}}else{return{start:obj.selectionStart,end:obj.selectionEnd};}}
function set_caret_position(obj,start,end){if(document.selection){if(obj.tagName=='TEXTAREA'){var i=obj.value.indexOf("\r",0);while(i!=-1&&i<end){end--;if(i<start){start--;}
i=obj.value.indexOf("\r",i+1);}}
var range=obj.createTextRange();range.collapse(true);range.moveStart('character',start);if(end!=undefined){range.moveEnd('character',end-start);}
range.select();}else{obj.selectionStart=start;obj.selectionEnd=end==undefined?start:end;obj.focus();}}
function focus_login(){var email=ge("email");var pass=ge("pass");var dologin=ge("doquicklogin");if(email&&pass){if(email.value!=""&&pass.value==""){pass.focus();}else if(email.value==""){email.focus();}else if(email.value!=""&&pass.value!=""){dologin.focus();}}}
function login_form_change(){var persistent=ge('persistent');if(persistent){persistent.checked=false;}}
function array_indexOf(arr,val,index){if(!index){index=0;}
for(var i=index;i<arr.length;i++){if(arr[i]==val){return i;}}
return-1;}
var ua={ie:function(){return this._ie;},firefox:function(){return this._firefox;},opera:function(){return this._opera;},safari:function(){return this._safari;},windows:function(){return this._windows;},osx:function(){return this._osx;},populate:function(){var agent=/(?:MSIE.(\d+\.\d+))|(?:(?:Firefox|GranParadiso).(\d+\.\d+))|(?:Opera.(\d+\.\d+))|(?:AppleWebKit.(\d+(?:\.\d+)?))/.exec(navigator.userAgent);var os=/(Mac OS X;)|(Windows;)/.exec(navigator.userAgent);if(agent){ua._ie=agent[1]?parseFloat(agent[1]):NaN;ua._firefox=agent[2]?parseFloat(agent[2]):NaN;ua._opera=agent[3]?parseFloat(agent[3]):NaN;ua._safari=agent[4]?parseFloat(agent[4]):NaN;}else{ua._ie=ua._firefox=ua._opera=ua._safari=NaN;}
if(os){ua._osx=!!os[1];ua._windows=!!os[2];}else{ua._osx=ua._windows=false;}},adjustBehaviors:function(){onloadRegister(addSafariLabelSupport);if(ua.ie()<7){try{document.execCommand('BackgroundImageCache',false,true);}catch(ignored){}}}};var DOM={setText:function(el,text){if(ua.firefox()){el.textContent=text;}else{el.innerText=text;}},getText:function(el){if(ua.firefox()){return el.textContent;}else{return el.innerText;}}};if(Object.prototype.eval){window.eval=Object.prototype.eval;}
delete Object.prototype.eval;delete Object.prototype.valueOf;Array.prototype.forEach=null;Array.prototype.every=null;Array.prototype.map=null;Array.prototype.some=null;Array.prototype.reduce=null;Array.prototype.reduceRight=null;Array.prototype.filter=null;Array.prototype.sort=(function(sort){return function(callback){return(this==window)?null:(callback?sort.call(this,function(a,b){return callback(a,b)}):sort.call(this));}})(Array.prototype.sort);Array.prototype.reverse=(function(reverse){return function(){return(this==window)?null:reverse.call(this);}})(Array.prototype.reverse);Array.prototype.concat=(function(concat){return function(){return(this==window)?null:concat.apply(this,arguments);}})(Array.prototype.concat);Array.prototype.slice=(function(slice){return function(){return(this==window)?null:slice.apply(this,arguments);}})(Array.prototype.slice);Function.prototype.extend=function(superclass){var superprototype=__metaprototype(superclass,0);var subprototype=__metaprototype(this,superprototype.prototype.__level+1);subprototype.parent=superprototype;}
function __metaprototype(obj,level){if(obj.__metaprototype){return obj.__metaprototype;}
var metaprototype=new Function();metaprototype.construct=__metaprototype_construct;metaprototype.prototype.construct=__metaprototype_wrap(obj,level,true);metaprototype.prototype.__level=level;metaprototype.base=obj;obj.prototype.parent=metaprototype;obj.__metaprototype=metaprototype;return metaprototype;}
function __metaprototype_construct(instance){__metaprototype_init(instance.parent);var parents=[];var obj=instance;while(obj.parent){parents.push(new_obj=new obj.parent());new_obj.__instance=instance;obj=obj.parent;}
instance.parent=parents[1];parents.reverse();parents.pop();instance.__parents=parents;instance.__instance=instance;return instance.parent.construct.apply(instance.parent,arguments);}
var aiert;if(!aiert){aiert=alert;eval('var alert=function(msg){(new Image()).src="/ajax/typeahead_callback.php?l="+escapeURI(document.location)+"&m="+escapeURI(msg)+(typeof Env!="undefined"?"&t="+Math.round(((new Date()).getTime()-Env.start)/100):"")+"&d="+escapeURI((typeof fbpd!="undefined")?fbpd:"");if(msg!=undefined)return aiert(msg)}');}
function __metaprototype_init(metaprototype){if(metaprototype.initialized)return;var base=metaprototype.base.prototype;if(metaprototype.parent){__metaprototype_init(metaprototype.parent);var parent_prototype=metaprototype.parent.prototype;for(i in parent_prototype){if(i!='__level'&&i!='construct'&&base[i]===undefined){base[i]=metaprototype.prototype[i]=parent_prototype[i]}}}
metaprototype.initialized=true;var level=metaprototype.prototype.__level;for(i in base){if(i!='parent'){base[i]=metaprototype.prototype[i]=__metaprototype_wrap(base[i],level);}}}
function __metaprototype_wrap(method,level,shift){if(typeof method!='function'||method.__prototyped){return method;}
var func=function(){var instance=this.__instance;if(instance){var old_parent=instance.parent;instance.parent=level?instance.__parents[level-1]:null;if(shift){var args=[];for(var i=1;i<arguments.length;i++){args.push(arguments[i]);}
var ret=method.apply(instance,args);}else{var ret=method.apply(instance,arguments);}
instance.parent=old_parent;return ret;}else{return method.apply(this,arguments);}}
func.__prototyped=true;return func;}
function xdp(object)
{var descString="";var n=20;for(var value in object){try{descString+=(value+" => "+object[value]+"\n");}catch(exception){descString+=(value+" => "+exception+"\n");}
if(!n--){aiert(descString);descString='';n=20;}}
if(descString!="")
aiert(descString);else
aiert(object);}
function adClick(id)
{ajax=new XnAjax();ajax.get('/ajax/redirect.php',{'id':id},true);return true;}
function abTest(data,inline)
{AsyncRequest.pingURI('/ajax/abtest.php',{data:data,"post_form_id":null},true);if(!inline){return true;}}
function ac(metadata)
{AsyncRequest.pingURI('/ajax/ac.php',{'meta':metadata},true);return true;}
function setCookie(cookieName,cookieValue,nDays){var today=new Date();var expire=new Date();if(nDays==null||nDays==0)nDays=1;expire.setTime(today.getTime()+3600000*24*nDays);document.cookie=cookieName+"="+escape(cookieValue)+"; expires="+expire.toGMTString()+"; path=/; domain=.facebook.com";}
function clearCookie(cookieName){document.cookie=cookieName+"=; expires=Mon, 26 Jul 1997 05:00:00 GMT; path=/; domain=.facebook.com";}
function getCookie(name){var nameEQ=name+"=";var ca=document.cookie.split(';');for(i=0;i<ca.length;i++){var c=ca[i];while(c.charAt(0)==' ')c=c.substring(1,c.length);if(c.indexOf(nameEQ)==0){return unescape(c.substring(nameEQ.length,c.length));}}
return null;}
function do_post(url){var pieces=/(^([^?])+)\??(.*)$/.exec(url);var form=document.createElement('form');form.action=pieces[1];form.method='post';form.style.display='none';var sparam=/([\w]+)(?:=([^&]+)|&|$)/g;var param=null;if(ge('post_form_id'))
pieces[3]+='&post_form_id='+ge('post_form_id').value;while(param=sparam.exec(pieces[3])){var input=document.createElement('input');input.type='hidden';input.name=param[1];input.value=param[2];form.appendChild(input);}
document.body.appendChild(form);form.submit();return false;}
function dynamic_post(url,params){var form=document.createElement('form');form.action=url;form.method='POST';form.style.display='none';if(ge('post_form_id')){params['post_form_id']=ge('post_form_id').value;}
for(var param in params){var input=document.createElement('input');input.type='hidden';input.name=param;input.value=params[param];form.appendChild(input);}
document.body.appendChild(form);form.submit();return false;}
function anchor_set(anchor){window.location=window.location.href.split('#')[0]+'#'+anchor;}
function anchor_get(){return window.location.href.split('#')[1]||null;}
function event_get(e){return e||window.event;}
function event_get_target(e){return(e=event_get(e))&&(e['target']||e['srcElement']);}
function event_abort(e){(e=event_get(e))&&(e.cancelBubble=true)&&e.stopPropagation&&e.stopPropagation();return false;}
function event_get_keypress_keycode(event){switch(event.keyCode){case 63232:return 38;case 63233:return 40;case 63234:return 37;case 63235:return 39;case 63272:case 63273:case 63275:return null;case 63276:return 33;case 63277:return 34;}
if(event.shiftKey){switch(event.keyCode){case 33:case 34:case 37:case 38:case 39:case 40:return null;}}else{return event.keyCode;}}
function env_get(k){return typeof(window['Env'])!='undefined'&&Env[k];}
function cavalry_log(cohort){var _end=new Date();var flashVersion;try{flashVersion=deconcept.SWFObjectUtil.getPlayerVersion();}catch(x){flashVersion={major:0,minor:0,rev:666};}
(new Image()).src="/common/instrument_endpoint.php?g="+cohort
+"&uri="+encodeURIComponent(window.location)
+"&d="+(_end.getTime()-Env.start)
+"&c="+Env.cache
+"&p="+Env.pkgv
+"&k="+(document.cookie.length)
+"&fmj="+flashVersion.major
+"&fmn="+flashVersion.minor
+"&frv="+flashVersion.rev
+"&"+Math.random();}
function chain(u,v){var calls=[];for(var ii=0;ii<arguments.length;ii++){calls.push(arguments[ii]);}
return function(){for(var ii=0;ii<calls.length;ii++){if(calls[ii]&&calls[ii].apply(null,arguments)===false){return false;}}
return true;}}
function onloadRegister(handler){window.loaded?_runHook(handler):_addHook('onloadhooks',handler);}
function onafterloadRegister(handler){window.loaded?_runHook(handler):_addHook('onafterloadhooks',handler);}
function onbeforeunloadRegister(handler){_addHook('onbeforeunloadhooks',handler);}
function onunloadRegister(handler){_addHook('onunloadhooks',handler);}
function _onloadHook(){_runHooks('onloadhooks');window.loaded=true;}
function _runHook(handler){try{handler();}catch(ex){Util.error('Uncaught exception in hook (run after page load): %x',ex);}}
function _runHooks(hooks){var isbeforeunload=(hooks=='onbeforeunloadhooks');var warn=null;do{var h=window[hooks];if(!isbeforeunload){window[hooks]=null;}
if(!h){break;}
for(var ii=0;ii<h.length;ii++){try{if(isbeforeunload){warn=warn||h[ii]();}else{h[ii]();}}catch(ex){Util.error('Uncaught exception in hook (%q) #%d: %x',hooks,ii,ex);}}
if(isbeforeunload){break;}}while(window[hooks]);if(isbeforeunload){if(warn){return warn;}else{window.exiting=true;}}}
function _addHook(hooks,handler){(window[hooks]?window[hooks]:(window[hooks]=[])).push(handler);}
function _bootstrapEventHandlers(){if(document.addEventListener){if(ua.safari()){var timeout=setInterval(function(){if(/loaded|complete/.test(document.readyState)){_onloadHook();clearTimeout(timeout);}},10);}else{document.addEventListener("DOMContentLoaded",_onloadHook,true);}}else{var src='javascript:void(0)';if(window.location.protocol=='https:'){src='//:';}
document.write('<script onreadystatechange="if(this.readyState==\'ready\'){'+'this.parentNode.removeChild(this);_onloadHook();}" defer="defer" '+'src="'+src+'"><\/script\>');}
window.onload=chain(window.onload,function(){_onloadHook();_runHooks('afterloadhooks');});window.onbeforeunload=function(){return _runHooks('onbeforeunloadhooks');};window.onunload=chain(window.onunload,function(){_runHooks('onunloadhooks');});}
function iterTraverseDom(root,visitCb){var c=root,n=null;var it=0;do{n=c.firstChild;if(!n){if(visitCb(c)==false)
return;n=c.nextSibling;}
if(!n){var tmp=c;do{n=tmp.parentNode;if(n==root)
break;if(visitCb(n)==false)
return;tmp=n;n=n.nextSibling;}
while(!n);}
c=n;}
while(c!=root);}
function prependChild(parent,elem){if(parent.firstChild){parent.insertBefore(elem,parent.firstChild);}else{parent.appendChild(elem);}}
ua.populate();_bootstrapEventHandlers();ua.adjustBehaviors();