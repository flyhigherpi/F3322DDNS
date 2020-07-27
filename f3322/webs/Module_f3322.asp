<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - F3322DDNS服务</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" language="JavaScript" src="/js/table/table.js"></script>
<script type="text/javascript" language="JavaScript" src="/client_function.js"></script>
<script type="text/javascript" src="/res/ss-menu.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/res/tablednd.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/dbconf?p=ss&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<style>
</style>
<script>
var db_f3322={}

function E(e) {
	return (typeof(e) == 'string') ? document.getElementById(e) : e;
}
function init() {
	show_menu(menu_hook);
	//sc_load_lang("music"); //20200515未知方法
	get_dbus_data();
	check_status();
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		type: "GET",
		url: "/_api/f3322",
		async: false,
		success: function(data) {
			//db_unblockmusic = db_unblockmusic_;
			db_f3322 = data.result[0];
			E("f3322_enable").checked = db_f3322["f3322_enable"] == "1";
			if(db_f3322["f3322_hostname"]){
				E("f3322_hostname").value = db_f3322["f3322_hostname"];
			}
			if(db_f3322["f3322_user"]){
				E("f3322_user").value = db_f3322["f3322_user"];
			}
			if(db_f3322["f3322_password"]){
				E("f3322_password").value = db_f3322["f3322_password"];
			}

		}
	});
}
function save() {
	showLoading(3);
	refreshpage(3);
	var id = parseInt(Math.random() * 100000000);
	db_f3322["f3322_enable"] = E("f3322_enable").checked ? '1' : '0';
	db_f3322["f3322_hostname"] = E("f3322_hostname").value;
	db_f3322["f3322_user"] = E("f3322_user").value;
	db_f3322["f3322_password"] = E("f3322_password").value;
	var postData = {"id": id, "method": "f3322_config.sh", "params":"restart", "fields": db_f3322};
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
	});
}
function check_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "f3322_status.sh", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		url: "/_api/",
		async: true,
		data: JSON.stringify(postData),
		success: function (response) {
			//console.log(response)
			E("f3322_status").innerHTML = response.result;
			setTimeout("check_status();", 10000);
		},
		error: function(){
			E("f3322_status").innerHTML = "获取运行状态失败";
			setTimeout("check_status();", 5000);
		}
	});
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "F3322-DDNS");
	tablink[tablink.length -1] = new Array("", "Module_f3322.asp");
}
</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<input type="hidden" name="current_page" value="Module_f3322.asp"/>
<input type="hidden" name="next_page" value="Module_f3322.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value="restart"/>
<input type="hidden" name="action_script" value="f3322_config.sh"/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<table class="content" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td width="17">&nbsp;</td>
        <td valign="top" width="202">
            <div id="mainMenu"></div>
            <div id="subMenu"></div>
        </td>
        <td valign="top">
            <div id="tabMenu" class="submenuBlock"></div>
            <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
                						<div id="f3322_title" style="float:left;" class="formfonttitle" style="padding-top: 12px" >F3322-DDNS</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote" id="head_illustrate"><i></i><em>F3322 DDNS服务</em></div>
										<div id="cpufreq_switch" style="margin:0px 0px 0px 0px;">
                							<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="2">设置</td>
												</tr>
												</thead>
												<tr>
													<th >Enable</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="f3322_enable">
																<input id="f3322_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>
												<tr>
													<th >Status</th>
													<td colspan="2"  id="f3322_status">
													</td>
												</tr>
												<tr id="f3322_hostname_tr">
													<th>
														<label >F3322 服务器</label>
													</th>
													<td>
														<input type="text" id="f3322_hostname" name="f3322_hostname" class="input_ss_table" style="width:200px;" placeholder="填入你的F3322服务器域名" />
													</td>
												</tr>
												<tr id="f3322_user_tr">
													<th>
														<label >用户名或E-mail帐号</label>
													</th>
													<td>
														<input type="text" id="f3322_user" name="f3322_user" class="input_ss_table" style="width:200px;" placeholder="" />
													</td>
												</tr>
												<tr id="f3322_password_tr">
													<th>
														<label >密码或 DDNS 密钥</label>
													</th>
													<td>
														<input type="text" id="f3322_password" name="f3322_password" class="input_ss_table" style="width:200px;" placeholder="" />
													</td>
												</tr>												
											</table>
										</div>
										<div class="apply_gen">
											<input  id="cmdBtn" type="button" class="button_gen" onclick="save()" value="Apply"/>
										</div>										
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
        </td>
    </tr>
</table>
<div id="footer"></div>
</body>
</html>

