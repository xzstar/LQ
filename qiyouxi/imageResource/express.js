/* Jun, Teiron.
 created for PPHelper
 */

var swfu;
var currentPath;
var systemPath;
var userPath;

function initSwfUpload(uploadUrl, upToken)
{
	var settings = 
	{

        upload_url: uploadUrl+"?action=upload",

        file_size_limit : "2 GB",	
        file_types : "*.*",
        file_types_description : "All Files",
//        file_upload_limit : "10",
        file_queue_limit : "0",
        
        // Event Handler Settings (all my handlers are in the Handler.js file)
        swfupload_loaded_handler : swfUploadLoaded,
        file_dialog_start_handler : fileDialogStart,
        file_queued_handler : fileQueued,
        file_queue_error_handler : fileQueueError,
        file_dialog_complete_handler : fileDialogComplete,
        upload_start_handler : uploadStart,
        upload_progress_handler : uploadProgress,
        upload_error_handler : uploadError,
        upload_success_handler : uploadSuccess,
        upload_complete_handler : uploadComplete,
        
        // Button Settings
        button_image_url : "/-_-/uploadButton.png",
        button_placeholder_id : "multiUploadSWFPlaceholder",
        button_width: 120,
        button_height: 40,
        button_window_mode : SWFUpload.WINDOW_MODE.TRANSPARENT,
        
        // Flash Settings
        flash_url : "/-_-/swfupload.swf",
        
        custom_settings : {
            progressTarget : "fsUploadProgress",
            cancelButtonId : "btnCancelMultiUpload"
        },
        
        // Debug Settings
        debug: false
	};
    
	swfu = new SWFUpload(settings);
} 


var pathType;

function resetContnentTable(info){
    currentPath = info.currentPath;
    var entrys = info.entrys;
    pathType = info.pathType;
    var flag = new Boolean(0);
    var x;
    var html_content = '';
//    var isIE = !!window.ActiveXObject;
//    var isIE6 = isIE && !window.XMLHttpRequest;
    
    swfu.setUploadURL(currentPath+"?action=upload");
//    swfu.setUseQueryString(true);
    
    document.getElementById('currentPath').innerHTML = currentPath;
    
    if(pathType == 'system' || pathType == 'documents') {
//        document.getElementById('sideTools').style = 'xheight: 0px; width: 0px; margin-left:0px; margin-right:10px; position:relative; xbackground: #aaa; xpadding:5px;';
//        document.getElementById('sideTools').style.height=0 + 'px';
//        if(isIE && isIE6){
        swfu.setButtonDisabled(true);
        document.getElementById('createFolderBt').src='/-_-/createFolder_disabled.png';
//        }else {
//            document.getElementById('sideTools').style.visibility="hidden";
//            document.getElementById('sideTools').style.width=0 + 'px';
//            document.getElementById('browseContentWraper').style.width = 900 + 'px';
//        }
    }else {
//        document.getElementById('sideTools').style.xheight=300 + 'px';
//        if(isIE && isIE6){
        swfu.setButtonDisabled(false);
        document.getElementById('createFolderBt').src='/-_-/createFolder.png';
//        }else {
//            document.getElementById('sideTools').style.visibility="visible";
//            document.getElementById('sideTools').style.width=260 + 'px';
//            document.getElementById('browseContentWraper').style.width = 665 + 'px';
//        } 
    }
    
    html_content += '<table class="filesTable" width="100%" cellpadding="3px" cellspacing="0px">'+
                        '<thead>'+
                            '<tr>'+
                                '<td class="fileName" align="left">名称</td>'+
                                '<td class="fileLastMod" align="left">修改时间</td>'+
                                '<td class="fileSize" align="right" style="padding-right:30px;">大小</td>'+
                            '</tr>'+
                        '</thead>'+
                        '<tbody>'+
                            '<tr>'+
                                '<td class="fileName" height="3px"></td>'+
                                '<td class="fileLastMod"></td>'+
                                '<td class="fileSize" align="right"></td>'+
                            '</tr>';
    if(entrys.length > 0) 
    {
        for (x in entrys)
        {
            flag = !flag;
            if(flag) {
    html_content +=         '<tr class="even">';
            }else {
    html_content +=         '<tr class="odd">';
            }
            
    html_content +=             '<td class="fileName">';
            if(entrys[x].kind == 'directory' || entrys[x].kind == 'parentDirectory') {
    html_content +=                 '<a style="float:left; width: 320px; display: inline-block; overflow: hidden;" href="javascript:browse(\''+entrys[x].path+'\');" title="'+entrys[x].name+'">';
                if(entrys[x].kind == 'directory') {
    html_content +=                     '<img class="fileIcon" src="/-_-/FolderIcon.png" alt="*"/>';
                }else if(entrys[x].kind == 'parentDirectory') {
    html_content +=                     '<img class="fileIcon" src="/-_-/folderUp.png" alt="*"/>';
                }
            }else if(entrys[x].kind == 'file') {
    html_content +=                 '<a style="float:left; width: 320px; display: inline-block; overflow: hidden;" target=\"_blank\" href="'+entrys[x].path+'?action=look" title="'+entrys[x].name+'">'+
                                        '<img class="fileIcon" src="/-_-/FileIcon.png" alt="*"/>';
            }
    html_content +=         entrys[x].name+
                                    '</a>'+
                                '</td>';
//            if(entrys[x].kind != 'parentDirectory') {
    html_content +=             '<td class="fileLastMod">'+entrys[x].lastModified+'</td>'+
                                '<td class="fileSize" align="right">'+entrys[x].fileSize+'&nbsp;';
//            }
            if(entrys[x].kind == 'file') {
    html_content +=                 '<a target=\"_blank\" href="'+entrys[x].path+'?action=down">'+
                                        '<img class="downloadIcon" src="/-_-/downloadIcon.png" alt="d"/>'+'&nbsp;'+
                                    '</a>';
            }
            if(entrys[x].kind != 'parentDirectory' && pathType != 'system') {
    html_content +=                 '<img class="deleteIcon" src="/-_-/deleteIcon.png" onclick="javascript:if(confirm(\'确定删除“'+entrys[x].name.replace('\'','\\\'')+'”？\\n注意：操作请谨慎，不可恢复！\')) doGET(\''+encodeURIComponent(entrys[x].path).replace('\'','\\\'')+'\', \'action=delete\', browseHandler);"/>';
            }
    html_content +=             '</td>'+
                            '</tr>';
        } 
    }
    html_content +=     '</tbody>'+
                    '</table>';
    
    document.getElementById('browseContnent').innerHTML = html_content;
}

function loginHandler() {
    if (httpReady()) {
        var info = JSON.parse(xmlHttp.responseText); 
        systemPath = info.systemPath;
        userPath = info.userPath;
        var deviceName = info.deviceName;
        var loginPath = info.loginPath;
        
        document.title = deviceName;
        document.getElementById('deviceName').innerHTML = deviceName;
        doGET(loginPath,"action=browse", browseHandler);
    }
}

function browse(url) {
    var stats = swfu.getStats();
    if (stats.files_queued > 0) {
        if(confirm('浏览其他文件夹将会停止所有上传任务，确定执行此操作？')) {
            swfu.cancelQueue();
            doGET(url, 'action=browse', browseHandler);
        }
    }else {
        doGET(url, 'action=browse', browseHandler);
    }
}

function browseHandler() {
    if (httpReady()) {
        var info = JSON.parse(xmlHttp.responseText); 
        resetContnentTable(info);
    }
}

function createFolder() {
    if(pathType != 'system' && pathType != 'documents') {
        doGET(currentPath, 'action=createFolder&folderName='+encodeURIComponent(document.getElementById('createFolderText').value), createFolderHandler);
    }
    
}

var t;
function createFolderHandler() {
    if (httpReady()) {
        var info = JSON.parse(xmlHttp.responseText); 
        var rc = info.rc;
        var message = info.message;
        if(rc == '1') {
            resetContnentTable(info);
            document.getElementById('createFolderMsg').className = 'cfmessage';
            document.getElementById('createFolderText').value = '';
        }else{
            document.getElementById('createFolderMsg').className = 'errorText cfmessage';
        }
        document.getElementById('createFolderMsg').innerHTML = message;
        clearTimeout(t);
        t = setTimeout('timeHandler()', 4000);
    }
}

function timeHandler() {
    document.getElementById('createFolderMsg').innerHTML='';
    clearTimeout(t);
}

