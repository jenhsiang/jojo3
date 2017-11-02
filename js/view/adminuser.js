
Ext.onReady(function() {

    Ext.QuickTips.init();

    var Renderer = function(value) {
        if (value == 1) {
            return '是';
        } else if (value == 0) {
            return '否';
        }
    };
    Ext.define('Ext.ux.PageSizePlugin', {
        alias: 'plugin.pagesizeplugin',
        maximumSize: 200,
        beforeText: '每頁顯示',
        afterText: '條記錄',
        limitWarning: '不能超出設置的最大分頁數：',
        constructor: function(config) {
            var me = this;
            Ext.apply(me, config);
        },
        init: function(paging) {
            var me = this;
            me.combo = me.getPageSizeCombo(paging);
            paging.add(' ', me.beforeText, me.combo, me.afterText, ' ');
            me.combo.on('select', me.onChangePageSize, me);
            me.combo.on('keypress', me.onKeyPress, me);
        },
        getPageSizeCombo: function(paging) {
            var me = this,
                defaultValue = paging.pageSize || paging.store.pageSize || 25;
            return Ext.create('Ext.form.field.ComboBox', {
                store: new Ext.data.SimpleStore({
                    fields: ['text', 'value'],
                    data: me.sizeList || [['10', 10], ['25', 25], ['50', 50], ['100', 100], ['200', 200]]
                }),
                mode: 'local',
                displayField: 'text',
                valueField: 'value',
                allowBlank: true,
                triggerAction: 'all',
                width: 50,
                maskRe: /[0-9]/,
                enableKeyEvents: true,
                value: defaultValue
            });
        },
        onChangePageSize: function(combo) {
            var paging = combo.up('standardpaging') || combo.up('pagingtoolbar'),
                store = paging.store,
                comboSize = combo.getValue();
            store.pageSize = comboSize;
            store.loadPage(1);
        },
        onKeyPress: function(field, e) {
            if(Ext.isEmpty(field.getValue())) {
                return;
            }
            var me = this,
                fieldValue = field.getValue(),
                paging = me.combo.up('standardpaging') || me.combo.up('pagingtoolbar'),
                store = paging.store;
            if(e.getKey() == e.ENTER) {
                if(fieldValue < me.maximumSize) {
                    store.pageSize = fieldValue;
                    store.loadPage(1);
                } else {
                    Ext.MessageBox.alert('提示', me.limitWarning + me.maximumSize);
                    field.setValue('');
                }
            }
        },
        destory: function() {
            var me = this;
            me.combo.clearListeners();
            Ext.destroy(me.combo);
            delete me.combo;
        }
    });
	Ext.define('SurveyRecord', {
		extend: 'Ext.data.Model',
		fields: [
		    {name: 'a_idx', type: 'int'},
			{name: 'a_userid', type: 'string'},
			{name: 'a_username', type: 'string'},
			{name: 'a_passwd', type: 'string'},
			{name: 'a_userphone', type: 'string'},
			{name: 'a_email', type: 'string'},
			{name: 'admin', type: 'int'},
			{name: 'createtime', type: 'string'},
			{name: 'updatetime', type: 'string'}
		]
	});

    var store = new Ext.data.Store({
		pageSize: 20,
		proxy: {
			type: 'ajax',
			url: '/json/j_adminuser.jsp',
			reader: {
				type: 'json',
				totalProperty: 'totalCount',
				root: 'result',
				idProperty: 'a_idx'
			}
		},
		model: SurveyRecord,
        remoteSort: false,
        autoLoad: true,
        clearOnPageLoad :true
    });
   
    store.load();

    var columns = [
        {header: '帳號', dataIndex: 'a_userid', sortable: true},
        {header: '姓名', dataIndex: 'a_username', sortable: true},
        {header: '密碼', dataIndex: 'a_passwd', sortable: true},
        {header: '電話', dataIndex: 'a_userphone', sortable: true},
        {header: 'E-mail', dataIndex: 'a_email', sortable: true},
        {header: '是否為總管理者', dataIndex: 'admin',renderer:Renderer, sortable: true},
        {header: '建立時間', dataIndex: 'createtime', sortable: true},
        {header: '修改時間', dataIndex: 'updatetime', sortable: true}
    ];
    var myPagingToolbar = Ext.create('Ext.PagingToolbar', {
        store: store,
        displayInfo: true,
        doRefresh : function(){
            // Keep or remove these code
            var me = this,
                current = me.store.currentPage;

            if (me.fireEvent('beforechange', me, current) !== false) {
                me.store.loadPage(current);
            }
         }, moveNext : function(){
            var me = this,
            total = me.getPageData().pageCount,
            next = me.store.currentPage + 1;
        if (next <= total) {
            if (me.fireEvent('beforechange', me, next) !== false) {
                me.store.loadPage(next);
            }
        }
    },

    moveLast : function(){
        var me = this,
            last = me.getPageData().pageCount;

        if (me.fireEvent('beforechange', me, last) !== false) {
            me.store.loadPage(last);
        }
    },
    plugins: Ext.create('Ext.ux.PageSizePlugin', {
        //设置的最大分页数，防止用户输入太大数量，影响服务器性能
        limitWarning: 200
    	})
    });
    // grid start
    var grid = new Ext.grid.GridPanel({
        title: '使用者列表',
        region: 'center',
        loadMask: true,
        store: store,
        columns: columns,
		forceFit: true,
        bbar: myPagingToolbar ,
        tbar: [{ 
            xtype: 'buttongroup', 
            width: '100%', 
            columns: 6, 
            items: [{ 
                xtype: 'combobox', 
                fieldLabel:'請選擇搜尋欄位', 
                id:'select_status', 
                width: 220, 
                labelWidth:100, 
                store : Ext.create('Ext.data.Store',{ 
                    fields : ['name','value'], 
                    data : [{'name':'帳號','value':'a_userid'},{'name':'姓名','value':'a_username'},
                            {'name':'密碼', 'value': 'a_passwd'},{'name':'電話', 'value': 'a_userphone'}, 
                            {'name':'E-mail', 'value':'a_email'},{'name': '是否為總管理者', 'value': 'admin'},
                            {'name':'建立時間', 'value':'createtime'}, {'name': '修改時間', 'value':'updatetime'}] 
                }), 
                emptyText : '請選擇欄位', 
                displayField : 'name', 
                valueField : 'value',
                listeners:{ 
                    select: { 
                        fn: function(){ 
                            select_status = Ext.getCmp('select_status').getValue(); 
                            if (select_status) { 
                            	switch(select_status) {
                                case "admin":
                                	Ext.getCmp('select_data').hide() ;
                                	Ext.getCmp('date_s').hide();
                                	Ext.getCmp('date_e').hide() ;
                                	Ext.getCmp('check_admin').show();
                                    break;
                                case "createtime":
                                case "updatetime":
                                	Ext.getCmp('select_data').hide();
                                	Ext.getCmp('check_admin').hide();
                                	Ext.getCmp('date_s').show();
                                	Ext.getCmp('date_e').show();
                                    break;
                                default:
                                	Ext.getCmp('check_admin').hide();
                                	Ext.getCmp('date_s').hide();
                                	Ext.getCmp('date_e').hide();
                                	Ext.getCmp('select_data').show();
                            	} 
                            } 
                          
                        } 
                    } 
                } 
            },{ 
                xtype: 'textfield', 
                fieldLabel: '', 
                labelWidth: 5,   
                width: 250, 
                id: 'select_data'
            },{ 
                xtype: 'datefield', 
                fieldLabel: '', 
                labelWidth: 5, 
                id: 'date_s', 
                width: 100, 
                format: 'Y-m-d'
            },{ 
                xtype: 'datefield', 
                fieldLabel: '至', 
                width: 110, 
                labelWidth: 10, 
                id: 'date_e', 
                format: 'Y-m-d'
            },{ 
                xtype: 'combobox', 
                fieldLabel:'', 
                id:'check_admin', 
                width: 150, 
                labelWidth:5, 
                store : Ext.create('Ext.data.Store',{ 
                    fields : ['name','value'], 
                    data : [{'name':'是','value':1},{'name':'否','value':0}] 
                }), 
                emptyText : '請選擇是否為總管理者', 
                displayField : 'name', 
                valueField : 'value'
            },{ 
                xtype: 'button', 
                text: '搜索', 
                id: 'searchorder', 
               // icon: '/public/js/lib/Ext/resources/icons/search.png', 
                listeners:{ 
                    click: { 
                        fn: function(){ 
                        	select_status = Ext.getCmp('select_status').getValue();
                        	select_data = Ext.getCmp('select_data').getValue();
                        	date_s = Ext.getCmp('date_s').getValue();
                        	date_e = Ext.getCmp('date_e').getValue();
                        	check_admin = Ext.getCmp('check_admin').getValue();
                            loader = { 
                                    params : {} 
                            }; 
                            if (select_status) {
                            	 loader.params.select_status = select_status; 	
                            	switch(select_status) {
                                case "admin":
                                	if (check_admin) { 
                                        loader.params.check_admin = check_admin; 
                                    } 
                                    break;
                                case "createtime":
                                case "updatetime":
                                	 if (date_s) { 
                                         loader.params.date_s = date_s.getFullYear() + '-' + (date_s.getMonth() + 1) + '-' + date_s.getDate(); 
                                     } 
                                     if (date_e) { 
                                         loader.params.date_e = date_e.getFullYear() + '-' + (date_e.getMonth() + 1) + '-' + date_e.getDate(); 
                                     } 
                                    break;
                                default:
                                	if (select_data) { 
                                        loader.params.select_data = select_data; 
                                    } 
                            	} 
                            } 
                            store.load(loader); //将参数加载给store 
                        } 
                    } 
                } 
            }] 
        }],
        listeners:{
            afterrender:function(){
            	store.load();
            	 select_status = Ext.getCmp('select_status').getValue(); 
                // if (select_status) { 
                 	switch(select_status) {
                     case "admin":
                     	Ext.getCmp('select_data').hide() ;
                     	Ext.getCmp('date_s').hide();
                     	Ext.getCmp('date_e').hide() ;
                     	Ext.getCmp('check_admin').show();
                         break;
                     case "createtime":
                     case "updatetime":
                     	Ext.getCmp('select_data').hide();
                     	Ext.getCmp('check_admin').hide();
                     	Ext.getCmp('date_s').show();
                     	Ext.getCmp('date_e').show();
                         break;
                     default:
                     	Ext.getCmp('check_admin').hide();
                     	Ext.getCmp('date_s').hide();
                     	Ext.getCmp('date_e').hide();
                     	Ext.getCmp('select_data').show();
                 	} 
                // } 
            }
           }
    });
    // grid end
    // form start
    var form = new Ext.form.FormPanel({
        title: '編輯使用者列表',
        region: 'south',
        frame: true,
        width: 260,
        autoHeight: true,
        autoScroll : true,
       // defaultType: 'textfield',
       /* defaults: {
			labelAlign: 'right',
			labelWidth: 60
        },*/ 
        items: [{
            layout:'column',   //定义该元素为布局为列布局方式
            border:false,
            labelSeparator:'：',
            items:[{
            	 xtype: 'hidden',
                 name: 'a_idx'
            },{
                columnWidth:.25,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '帳號',
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'a_userid',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 50,//最大值 
                    maxLengthText :"最多可輸入50個字"
                }]
            },{
                columnWidth:.25,
                layout: 'form',
                border:false,
                items: [{
                   // cls : 'key',
                    xtype:'textfield',
                    //inputType:'password',
                    fieldLabel: '姓名',
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'a_username',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 50,//最大值 
                    maxLengthText :"最多可輸入50個字"
                }]
            },{
                columnWidth:.25,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '密碼',
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'a_passwd',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 50,//最大值 
                    maxLengthText :"最多可輸入50個字"
                }]
            },
            {
                columnWidth:.25,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '電話',
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'a_userphone',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 50,//最大值 
                    maxLengthText :"最多可輸入50個字"
                }]
            },{
                columnWidth:.25,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: 'E-mail',
                	vtype:"email",//email格式验证
                    vtypeText:"不是有效的E-mail",//错误提示信息,默认值我就不说了
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                	name: 'a_email',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 50,//最大值 
                    maxLengthText :"最多可輸入50個字"
                }]
            },{
                columnWidth:.25,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行	
                	fieldLabel: '是否為總管理者',
                    name: 'admin',
                    xtype: 'combo',
                    store: new Ext.data.SimpleStore({
                        fields: ['value','text'],
                        data: [[1,'是'],[0,'否']]
                    }),
                    emptyText: '請選擇',
                    mode: 'local',
                    triggerAction: 'all',
                    valueField: 'value',
                    displayField: 'text',
                    editable: false,
                    allowBlank :false,
                    blankText : "請選擇'是'或'否'"
                }]
            },{
                columnWidth:.25,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '資料建立時間',
                    name: 'createtime',
                    labelAlign: 'right',
                    anchor:'90%',
                    readOnly : true
                }]
            },{
                columnWidth:.25,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '資料修改時間',
                    name: 'updatetime',
                    labelAlign: 'right',
                    anchor:'90%',
                    readOnly : true
                }]
            }]
        }],
        buttons: [{
			id: 'buttonSave',
            text: '增加',
            handler: function() {
                if (!form.getForm().isValid()) {
                    return;
                }
                if (form.getForm().findField("a_idx").getValue() == "") {
                    // 添加
                    form.getForm().submit({
                    	timeout : 60,
                    	waitMsg : "正在處理中.....",
                        url: '/controller/adminuser_save.jsp',
                        success: function(f, action) {
                            if (action.result.success == 1) {
                                Ext.Msg.alert('消息', action.result.msg, function() {
                                    grid.getStore().reload();
                                    form.getForm().reset();
									Ext.getCmp('buttonSave').setText('增加');
                                });
                            }else if(action.result.success == 2){
                            	Ext.Msg.alert('消息', action.result.msg, function() {
                                    grid.getStore().reload();
                                    form.getForm().findField("a_idx").setValue("");
									Ext.getCmp('buttonSave').setText('增加');
                                });
                            }
                        },
                        failure: function(form, action) {
                        	switch (action.failureType) {  
                            case Ext.form.Action.CLIENT_INVALID :  
                                Ext.Msg.alert('错误！', '存在未通过验证的数据!');  
                                break;  
                            case Ext.form.Action.CONNECT_FAILURE :  
                                Ext.Msg.alert('错误！', '连接错误!');  
                                break;  
                            case Ext.form.Action.SERVER_INVALID :  
                                Ext.Msg.alert('错误!', action.result.msg);  
                        }  
                            Ext.Msg.alert('錯誤', "增加失敗");
                        }
                    });
                } else {
                    // 修改
                    form.getForm().submit({
                    	timeout : 60,
                    	waitMsg : "正在處理中.....",
                        url: '/controller/adminuser_save.jsp',
                        success: function(f, action) {
                            if (action.result.success == 1) {
                                Ext.Msg.alert('消息', action.result.msg, function() {
                                    grid.getStore().reload();
                                    form.getForm().reset();
									Ext.getCmp('buttonSave').setText('增加');
                                });
                            }else if(action.result.success == 2){
                            	Ext.Msg.alert('消息', action.result.msg, function() {
                                    grid.getStore().reload();
                                    form.getForm().findField("a_userid").setValue("");
									Ext.getCmp('buttonSave').setText('增加');
                                });
                            }
                        },
                        failure: function(form, action) {
                        	switch (action.failureType) {  
                            case Ext.form.Action.CLIENT_INVALID :  
                                Ext.Msg.alert('错误！', '存在未通过验证的数据!');  
                                break;  
                            case Ext.form.Action.CONNECT_FAILURE :  
                                Ext.Msg.alert('错误！', '连接错误!');  
                                break;  
                            case Ext.form.Action.SERVER_INVALID :  
                                Ext.Msg.alert('错误!', action.result.msg);  
                        }  
                            Ext.Msg.alert('錯誤', "修改失敗");
                        }
                    });
                }
            }
        },{
            text: '清空',
            handler: function() {
                form.getForm().reset();
				Ext.getCmp('buttonSave').setText('增加');
            }
        },{
            text: '删除',
            handler: function() {
                var id = form.getForm().findField('a_idx').getValue();
                if (id == '') {
                    Ext.Msg.alert('提示', '請選擇需要删除的資料。');
                } else {
                	Ext.MessageBox.confirm('消息','確定刪除此資料?',function(btn){
                		if(btn == 'yes'){
                			Ext.Ajax.request({
                                url: '/controller/adminuser_remove.jsp',
                                success: function(response) {
                                    var json = Ext.decode(response.responseText);
                                    if (json.success) {
                                        Ext.Msg.alert('消息', json.msg, function() {
                                            grid.getStore().reload();
                                            form.getForm().reset();
        									Ext.getCmp('buttonSave').setText('增加');
                                        });
                                    }
                                },
                                failure: function() {
                                    Ext.Msg.alert('錯誤', "删除失敗");
                                },
                                params: "a_idx=" + id
                            });
                		}
                	});
                }
            }
        }]
    });
    // form end

    // 单击修改信息 start
    grid.on('itemclick', function(view, record) {
        form.getForm().loadRecord(record);
        Ext.getCmp('buttonSave').setText('修改');
    });
    // 单击修改信息 end

    // layout start
    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [{
            region: 'north',
            contentEl: 'head'
        }, grid, form, {
            region: 'south',
            contentEl: 'foot'
        }]
    });
    // layout end
});

