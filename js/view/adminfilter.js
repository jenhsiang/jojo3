
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
		    {name: 'idx', type: 'int'},
		    {name: 'ipaddress', type: 'string'},
			{name: 'i_order', type: 'int'},
			{name: 'createtime', type: 'string'},
			{name: 'updatetime', type: 'string'}
		]
	});

    var store = new Ext.data.Store({
		pageSize: 20,
		proxy: {
			type: 'ajax',
			url: '/json/j_adminfilter.jsp',
			reader: {
				type: 'json',
				totalProperty: 'totalCount',
				root: 'result',
				idProperty: 'idx'
			}
		},
		model: SurveyRecord,
        remoteSort: false,
        autoLoad: true,
        clearOnPageLoad :true
    });
   
    store.load();

    var columns = [
         {header: '順序', dataIndex: 'i_order', sortable: true,flex : 1},
         {header: '限制IP位址', dataIndex: 'ipaddress', sortable: true,flex : 2},
         {header: '建立時間', dataIndex: 'createtime', sortable: true,flex : 2},
         {header: '修改時間', dataIndex: 'updatetime', sortable: true,flex : 2}
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
        title: '限制IP位址列表',
        region: 'center',
        loadMask: true,
        store: store,
        columns: columns,
		forceFit: true,
        bbar: myPagingToolbar ,
        tbar:[{ 
                xtype: 'combobox', 
                fieldLabel:'請選擇搜尋欄位', 
                id:'select_status', 
                width: 220, 
                labelWidth:100, 
                store : Ext.create('Ext.data.Store',{ 
                    fields : ['name','value'], 
                    data : [{'name':'順序','value':'i_order'},{'name':'限制IP位址','value':'ipaddress'},
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
                                case "createtime":
                                case "updatetime":
                                	Ext.getCmp('select_data').hide();
                                	Ext.getCmp('date_s').show();
                                	Ext.getCmp('date_e').show();
                                    break;
                                default:
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
                            loader = { 
                                    params : {} 
                            }; 
                            if (select_status) {
                            	 loader.params.select_status = select_status; 	
                            	switch(select_status) {
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
            },'->',{
    	        xtype: 'label',
    	        text: '限制IP位址順序調整:',
    	        margins: '0 0 0 10'
    	    	},
    		      {  
    	        text : '上移',  
    	        xtype: 'button',
    	        handler: function() {  
    	           // var grid = fieldSet.child("[xtype=gridpanel]");  
    	            var records = grid.getSelectionModel().getSelection();  
    	            for(var i in records) {  
    	                var record = records[i];  
    	                var index = store.indexOf(record);  
    	                if (index > 0) {  
    	                    store.removeAt(index);  
    	                    store.insert(index - 1, record);  
    	                    grid.getView().refresh();  
    	                    grid.getSelectionModel().selectRange(index - 1, index - 1);
    	                }  
    	            }  
    	      
    	        }  
    	    },{  
    	        text : '下移',  
    	        xtype: 'button',  
    	        handler: function() {  
    	          //  var grid = fieldSet.child("[xtype=gridpanel]");  
    	            var records = grid.getSelectionModel().getSelection();  
    	            for(var i in records) {  
    	                var record = records[i]; 
    	                var index = store.indexOf(record);  
    	                if (index < store.getCount() - 1) {  
    	                    store.removeAt(index);  
    	                    store.insert(index + 1, record);  
    	                    grid.getView().refresh();  
    	                    grid.getSelectionModel().selectRange(index + 1, index + 1);    
    	                }  
    	            }  
    	        }  
    	    },{  
    	    	id: 'buttonOrder',
    	        text : '確定',  
    	        xtype: 'button',  
    	        handler: function() {
    	        	Ext.getCmp('buttonOrder').disabled = true;
    	        	var orderarr =[];
    	        	 store.each(function(record) {
    	        		 orderarr.push(record.get('idx'));
    		            });
    	        	 Ext.Ajax.request({
                         url: '/controller/adminfilter_order.jsp',
                         params: {
                        	 "orderarr":JSON.stringify(orderarr),
                             "pagesize" : store.pageSize,
                             "currentpage" : store.currentPage
                         },
                         success: function(response) {
                             var json = Ext.decode(response.responseText);
                              console.log(json);
                             //console.log(response.success);
                             if (json.success == 1) {
                            	 Ext.getCmp('buttonOrder').disabled = false;
                                 Ext.Msg.alert('消息', '更改順序成功', function() {
                                     grid.getStore().reload();
                                     form.getForm().reset();
    								 Ext.getCmp('buttonSave').setText('增加');
                                 });
                             }else{
                            	 Ext.Msg.alert('消息', '更改順序失敗', function() {
                                     grid.getStore().reload();
                                    form.getForm().reset();
    								Ext.getCmp('buttonSave').setText('增加');
                                 }); 
                             }
                         },
                         failure: function(response) {
                        	 console.log(response);
                             Ext.Msg.alert('錯誤', "更改順序失敗");
                         }
                     });
    	        }  
    	    }] ,
        listeners:{
            afterrender:function(){
            	store.load();
            	 select_status = Ext.getCmp('select_status').getValue(); 
                // if (select_status) { 
                 	switch(select_status) {
                     case "createtime":
                     case "updatetime":
                     	Ext.getCmp('select_data').hide();
                     	Ext.getCmp('date_s').show();
                     	Ext.getCmp('date_e').show();
                         break;
                     default:
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
        title: '編輯限制IP位址列表',
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
                 name: 'idx'
            },{
                columnWidth:.5,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '順序',
                    name: 'i_order',
                    labelAlign: 'right',
                    anchor:'90%',
                    readOnly : true
                }]
            },{
                columnWidth:.5,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '限制IP位址',
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'ipaddress',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 20,//最大值 
                    maxLengthText :"最多可輸入20個字",
                    regex:/^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/,
                    regexText:"請輸入正確的IP地址"
                }]
            },{
                columnWidth:.5,  //该列占用的宽度，标识为50％
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
                columnWidth:.5,  //该列占用的宽度，标识为50％
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
                if (form.getForm().findField("idx").getValue() == "") {
                    // 添加
                    form.getForm().submit({
                    	timeout : 60,
                    	waitMsg : "正在處理中.....",
                        url: '/controller/adminfilter_save.jsp',
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
                                    form.getForm().findField("ipaddress").setValue("");
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
                        url: '/controller/adminfilter_save.jsp',
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
                                    form.getForm().findField("ipaddress").setValue("");
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
                var id = form.getForm().findField('idx').getValue();
                if (id == '') {
                    Ext.Msg.alert('提示', '請選擇需要删除的資料。');
                } else {
                	Ext.MessageBox.confirm('消息','確定刪除此資料?',function(btn){
                		if(btn == 'yes'){
                			Ext.Ajax.request({
                                url: '/controller/adminfilter_remove.jsp',
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
                                params: "idx=" + id
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

