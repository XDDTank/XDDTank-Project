// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.ListPanel

package com.pickgliss.ui.controls
{
    import com.pickgliss.ui.controls.cell.IListCellFactory;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.controls.list.List;
    import com.pickgliss.ui.controls.list.IListModel;
    import com.pickgliss.ui.controls.list.VectorListModel;

    public class ListPanel extends ScrollPanel 
    {

        public static const P_backgound:String = "backgound";
        public static const P_backgoundInnerRect:String = "backgoundInnerRect";
        public static const P_factory:String = "factory";

        protected var _factory:IListCellFactory;
        protected var _factoryStrle:String;
        protected var _listStyle:String;

        public function ListPanel()
        {
            super(false);
        }

        override public function dispose():void
        {
            this._factory = null;
            super.dispose();
        }

        public function set factoryStyle(_arg_1:String):void
        {
            if (this._factoryStrle == _arg_1)
            {
                return;
            };
            this._factoryStrle = _arg_1;
            var _local_2:Array = _arg_1.split("|");
            var _local_3:String = _local_2[0];
            var _local_4:Array = ComponentFactory.parasArgs(_local_2[1]);
            this._factory = ClassUtils.CreatInstance(_local_3, _local_4);
            onPropertiesChanged(P_factory);
        }

        public function get list():List
        {
            return (_viewSource as List);
        }

        public function get listModel():IListModel
        {
            return (this.list.model);
        }

        public function set listStyle(_arg_1:String):void
        {
            if (this._listStyle == _arg_1)
            {
                return;
            };
            this._listStyle = _arg_1;
            viewPort = ComponentFactory.Instance.creat(this._listStyle);
        }

        public function get vectorListModel():VectorListModel
        {
            if (this.list == null)
            {
                return (null);
            };
            return (this.list.model as VectorListModel);
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (((_changedPropeties[P_factory]) || (_changedPropeties[ScrollPanel.P_viewSource])))
            {
                if (this.list)
                {
                    this.list.cellFactory = this._factory;
                };
            };
        }


    }
}//package com.pickgliss.ui.controls

