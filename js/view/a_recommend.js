
Ext.onReady(function() {
    Ext.QuickTips.init();
	
    function fGridTooltips(value, metaData, record, rowIdx, colIdx, store) 
    {
    	//==>用tooltip浮窗,显示编码后单元格内的值
    	metaData.tdAttr = 'data-qtip="' + Ext.String.htmlEncode(value) + '"';
    	return value;
    } 
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
                editable: false,
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
    //deliver_main
	Ext.define('SurveyRecord', {
		extend: 'Ext.data.Model',
		fields: [
		    {name: 'seqnum', type: 'int'},
		    {name: 'recommend_id', type: 'int'},
		    {name: 'recommend_name', type: 'string'},
			{name: 'a_userid', type: 'string'},
			{name: 'createtime', type: 'string'},
			{name: 'updatetime', type: 'string'}
		]
	});
	//deliver_main
    var store = new Ext.data.Store({
		pageSize: 20,
		proxy: {
			type: 'ajax',
			url: '/json/j_a_recommend.jsp',
			//extraParams: {member_id : member_id,book_id : book_id,book_name : book_name},
			reader: {
				type: 'json',
				totalProperty: 'totalCount',
				root: 'result',
				idProperty: 'recommend_id'
			}
		},
		model: SurveyRecord,
        remoteSort: false,
        autoLoad: true,
        clearOnPageLoad :true
    });
    store.on('beforeload', function (store, options) {
    	if(Ext.getCmp('select_status')) var select_status = Ext.getCmp('select_status').getValue();
    	if(Ext.getCmp('select_data')) var select_data = Ext.getCmp('select_data').getValue();
		if(Ext.getCmp('check_userid')) var check_userid = Ext.getCmp('check_userid').getValue();
    	if(Ext.getCmp('date_s')) var date_s = Ext.getCmp('date_s').getValue();
    	if(Ext.getCmp('date_e')) var date_e = Ext.getCmp('date_e').getValue();
        var new_params = {select_status: select_status , select_data : select_data,
        				  check_userid : check_userid,
        				  date_s : date_s,date_e: date_e};
        Ext.apply(store.proxy.extraParams, new_params);
    });
    /*store.getProxy().extraParams = {
    	select_status: 'address',check_address : '仁愛門市自取'
    };*/
    store.load();

  //deliver_main
    var columns = [
        {header: '編號', dataIndex: 'recommend_id', renderer: fGridTooltips, sortable: true},
        {header: '推薦名稱', dataIndex: 'recommend_name', renderer: fGridTooltips, sortable: true},
		{header: '建立時間', dataIndex: 'createtime', renderer: fGridTooltips, sortable: true},
        {header: '修改時間', dataIndex: 'updatetime', renderer: fGridTooltips, sortable: true},
        {header: '最後管理者', dataIndex: 'a_userid', renderer: fGridTooltips, sortable: true}
    ];
  //deliver_main
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
        title: '推薦管理',
        region: 'center',
        collapsible: true,
        autoScroll : true,//自动显示滚动条
        //autoHeight:true,
        loadMask: true,
        store: store,
        columns: columns,
		forceFit: true,
        bbar: myPagingToolbar ,
        tbar: [{ 
                xtype: 'combobox', 
                fieldLabel:'請選擇搜尋欄位', 
                id:'select_status', 
                width: 220, 
                labelWidth:100, 
                editable: false,
                store : Ext.create('Ext.data.Store',{ 
                    fields : ['name','value'], 
                    data : [{'name':'推薦名稱','value':'recommend_name'},
							{'name':'建立時間','value':'createtime'},
                            {'name':'修改時間', 'value': 'updatetime'},
                            {'name':'最後管理者', 'value':'a_userid'}] 
                }), 
                emptyText : '請選擇欄位', 
                displayField : 'name', 
                valueField : 'value',
                listeners:{ 
                    select: { 
                        fn: function(){ 
                            var select_status = Ext.getCmp('select_status').getValue(); 
                            if (select_status) { 
                            	switch(select_status) {
								case "a_userid":
                                	Ext.getCmp('select_data').hide();
                                	Ext.getCmp('date_s').hide();
                                	Ext.getCmp('date_e').hide();
                                	Ext.getCmp('check_userid').show();
                                     break;
                            	case "createtime":
                            	case "updatetime":
								    Ext.getCmp('check_userid').hide();
                                	Ext.getCmp('select_data').hide();
                                	Ext.getCmp('date_s').show();
                                	Ext.getCmp('date_e').show();
                                    break;
                                default:
								    Ext.getCmp('check_userid').hide();
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
                id:'check_userid', 
                width: 150, 
                labelWidth:5, 
                editable: false,
                store : Ext.create('Ext.data.Store',{ 
                    fields : ['name','value'], 
					autoLoad: true,
					proxy: {
						type: 'ajax',
						url : '/json/j_combobox_userid.jsp',
						reader: {
							type: 'json',
							root: 'result'
						}
					} 
                }), 
                emptyText : '請選擇管理者', 
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
                        	var select_status = Ext.getCmp('select_status').getValue();
                        	var select_data   = Ext.getCmp('select_data').getValue();
							var check_userid   = Ext.getCmp('check_userid').getValue();
                        	var date_s 		  = Ext.getCmp('date_s').getValue();
                        	var date_e        = Ext.getCmp('date_e').getValue();
                            var loader = { 
                                    params : {} 
                            }; 
                            if (select_status) {
                            	 loader.params.select_status = select_status; 	
                            	switch(select_status) {
								case "a_userid":
                                	if (check_userid) { 
                                        loader.params.check_userid = check_userid; 
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
            }],
        listeners:{
            afterrender:function(){
            	store.load();
            	 var select_status = Ext.getCmp('select_status').getValue(); 
                // if (select_status) { 
            		switch(select_status) {
					case "a_userid":
                    	Ext.getCmp('select_data').hide();
                    	Ext.getCmp('date_s').hide();
                    	Ext.getCmp('date_e').hide();
                    	Ext.getCmp('check_userid').show();
                         break;
                	case "createtime":
                    case "updatetime":
						Ext.getCmp('check_userid').hide();
                    	Ext.getCmp('select_data').hide();
                    	Ext.getCmp('date_s').show();
                    	Ext.getCmp('date_e').show();
                        break;
                    default:
						Ext.getCmp('check_userid').hide();
                    	Ext.getCmp('date_s').hide();
                    	Ext.getCmp('date_e').hide();
                    	Ext.getCmp('select_data').show();
                	} 
                // } 
            }
           },
		  viewConfig: {
        forceFit: true,
        stripeRows: true/*,
        getRowClass: changeRowClass*/
		}
    });
	/*function changeRowClass(record, rowIndex, rowParams, store) {

       if (record.get("borrow_state") == 2 || record.get("borrow_state") == 4 ) {
        return 'x-grid-record-red';
       } 
	}*/
    // grid end
    // form start
    var form = new Ext.form.FormPanel({
        title:'推薦管理',
        region: 'south',
        frame: true,
        width: '100%',
        autoHeight: true,
        autoScroll : true,
        collapsible: true,
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
   	 			name: 'seqnum'
    			},{
                columnWidth:.3,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '編號',
                    allowBlank:true,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'recommend_id',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 50,//最大值 
                    maxLengthText :"最多可輸入50個字",
                    readOnly : true
                }]
            },{
                columnWidth:.7,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '類別名稱',
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'recommend_name',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 50,//最大值 
                    maxLengthText :"最多可輸入20個字"
                }]
            },{
                columnWidth:.3,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '建立時間',
                    name: 'createtime',
                    labelAlign: 'right',
                    anchor:'90%',
                    readOnly : true
                }]
            },{
                columnWidth:.3,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '修改時間',
                    name: 'updatetime',
                    labelAlign: 'right',
                    anchor:'90%',
                    readOnly : true
                }]
            },{
                columnWidth:.4,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '最後管理者',
                    name: 'a_userid',
                    labelAlign: 'right',
                    anchor:'90%',
                    readOnly : true
                }]
            }]
        }],
        buttons: [{
			id: 'buttonSave',
            text: '新增',
            handler: function() {
               /* if (form.getForm().findField("recommend_id").getValue() == "") {
                	alert('請選擇一筆資料');
                } else {*/
                    // 修改
                	if (!form.getForm().isValid()) {
                        return;
                    }
                    form.getForm().submit({
                    	timeout : 60,
                    	waitMsg : "正在處理中.....",
                        url: '/controller/a_recommend_save.jsp',
                        success: function(f, action) {
                            if (action.result.success == 1) {
                                Ext.Msg.alert('消息', action.result.msg, function() {
									grid.getStore().reload();
								  if(action.result.recommend_id != 0){
										store.reload({ 
											callback: function(records, options, success){ 
													form.loadRecord(records[action.result.seqnum]);
												} 
											}); 
								  }else{
									  form.getForm().reset();
								  }
                                });
                            }else if(action.result.success == 2){
								Ext.Msg.alert('消息', action.result.msg, function() {
                                    form.getForm().findField("recommend_name").setValue("");
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
              //  }
            }
        },{
            text: '清空',
            handler: function() {
                form.getForm().reset();
				Ext.getCmp('buttonSave').setText('新增');
            }
        }/*,{
            text: '删除',
            handler: function() {
                var id = form.getForm().findField('m_idx').getValue();
                if (id == '') {
                    Ext.Msg.alert('提示', '請選擇需要删除的資料。');
                } else {
                	Ext.MessageBox.confirm('消息','確定刪除此資料?',function(btn){
                		if(btn == 'yes'){
                			Ext.Ajax.request({
                                url: '/controller/delivermain_remove.jsp',
                                success: function(response) {
                                    var json = Ext.decode(response.responseText);
                                    if (json.success) {
                                        Ext.Msg.alert('消息', json.msg, function() {
                                            grid.getStore().reload();
                                            form.getForm().reset();
        									//Ext.getCmp('buttonSave').setText('增加');
                                        });
                                    }
                                },
                                failure: function() {
                                    Ext.Msg.alert('錯誤', "删除失敗");
                                },
                                params: "m_idx=" + id
                            });
                		}
                	});
                }
            }
        }*/]
    });
    // form end
    // 单击修改信息 start
   grid.on('itemclick', function(view, record) {
    	session_midx = record.data.borrow_id;
    	 var loader = { 
                 params : {} 
         }; 
    	 loader.params.borrow_id = session_midx;
    	// detail_store.load(loader); //将参数加载给store
        form.getForm().loadRecord(record);
       // detail_form.getForm().reset();
        Ext.getCmp('buttonSave').setText('修改');
    });
    // 单击修改信息 end
    // detail单击修改信息 start
    /* detail_grid.on('itemclick', function(view, record) {
    	detail_form.getForm().loadRecord(record);
       // Ext.getCmp('detail_buttonSave').setText('修改');
    });*/
    //detail 单击修改信息 end

    // layout start
    var viewport = new Ext.panel.Panel({
       // layout: 'border',
    	 //layout: 'absolute',
    	 //autoHeight: true,
         //border: false,
    	//autoScroll : true,
    	 title:'',  
         frame:true,//渲染面板  
         collapsible : true,//允许展开和收缩  
         renderTo: Ext.getBody(),  
         width : '100%',  
         bodyPadding: 1,  
        items: [
        {
            region: 'north',
            contentEl: 'head'
        },
        grid,
        form,
        //detail_grid,
       // detail_form,
        {
            region: 'south',
            contentEl: 'foot'
        }]
    });
    // layout end
});

