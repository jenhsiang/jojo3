
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
		    {name: 'id', type: 'int'},
			{name: 'identity', type: 'string'},
			{name: 'username', type: 'string'},
			{name: 'useremail', type: 'string'},
			{name: 'userphone', type: 'string'},
			{name: 'usermessage', type: 'string'},
			{name: 'createtime', type: 'string'}
		]
	});

    var store = new Ext.data.Store({
		pageSize: 20,
		proxy: {
			type: 'ajax',
			url: '/json/j_contact_form.jsp',
			reader: {
				type: 'json',
				totalProperty: 'totalCount',
				root: 'result',
				idProperty: 'id'
			}
		},
		model: SurveyRecord,
        remoteSort: false,
        autoLoad: true,
        clearOnPageLoad :true
    });
   
    store.load();

    var columns = [
        {header: '編號', dataIndex: 'id', sortable: true},
        {header: '身分', dataIndex: 'identity', sortable: true},
        {header: '姓名', dataIndex: 'username', sortable: true},
        {header: 'E-mail', dataIndex: 'useremail', sortable: true},
        {header: '電話', dataIndex: 'userphone', sortable: true},
        {header: '訊息', dataIndex: 'usermessage', sortable: true},
        {header: '來信時間', dataIndex: 'createtime', sortable: true}
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
        title: '官網『聯絡我們』列表',
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
                    data : [{'name':'編號','value':'id'},{'name':'身分','value':'identity'},
                            {'name':'姓名', 'value': 'username'},{'name':'E-mail', 'value': 'useremail'}, 
                            {'name':'電話', 'value':'userphone'},{'name': '訊息', 'value': 'usermessage'},
                            {'name':'來信時間', 'value':'createtime'}] 
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
                     case "createtime":
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
        title: '官網『聯絡我們』列表',
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
                columnWidth:.2,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '編號',
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'id',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 11,//最大值 
                    maxLengthText :"最多可輸入11個字",
                    readOnly : true
                }]
            },{
                columnWidth:.4,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '身分',
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'identity',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 20,//最大值 
                    maxLengthText :"最多可輸入20個字",
                    readOnly : true
                }]
            },{
                columnWidth:.4,
                layout: 'form',
                border:false,
                items: [{
                   // cls : 'key',
                    xtype:'textfield',
                    //inputType:'password',
                    fieldLabel: '姓名',
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'username',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 20,//最大值 
                    maxLengthText :"最多可輸入20個字",
                    readOnly : true
                }]
            },{
                columnWidth:.2,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '電話',
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'userphone',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 20,//最大值 
                    maxLengthText :"最多可輸入20個字",
                    readOnly : true
                }]
            },{
                columnWidth:.4,  //该列占用的宽度，标识为50％
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
                	name: 'useremail',
                    labelAlign: 'right',
                    anchor:'90%',
                    maxLength : 50,//最大值 
                    maxLengthText :"最多可輸入50個字",
                    readOnly : true
                }]
            },{
                columnWidth:.4,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textfield',
                    fieldLabel: '來信時間',
                    name: 'createtime',
                    labelAlign: 'right',
                    anchor:'90%',
                    readOnly : true
                }]
            },{
                columnWidth:1,  //该列占用的宽度，标识为50％
                layout: 'form',
                border:false,
                items: [{                     //这里可以为多个Item，表现出来是该列的多行
                    //cls : 'key',
                    xtype:'textareafield',
                    fieldLabel: '訊息',
                    allowBlank:false,//不允许为空
                    blankText:"不能為空，请填寫",//错误提示信息，默认为This field is required!
                    name: 'usermessage',
                    labelAlign: 'right',
                    anchor:'90%',
                    height :50,
                    maxLength : 500,//最大值 
                    maxLengthText :"最多可輸入500個字",
                    readOnly : true
                }]
            }]
        }]
    });
    // form end

    // 单击修改信息 start
    grid.on('itemclick', function(view, record) {
        form.getForm().loadRecord(record);
       // Ext.getCmp('buttonSave').setText('修改');
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

