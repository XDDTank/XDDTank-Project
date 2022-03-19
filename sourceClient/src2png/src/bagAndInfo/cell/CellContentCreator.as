// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.cell.CellContentCreator

package bagAndInfo.cell
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.view.character.ILayerFactory;
    import ddt.view.character.ILayer;
    import flash.utils.Timer;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.view.character.LayerFactory;
    import ddt.data.EquipType;
    import flash.events.TimerEvent;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.view.character.BaseLayer;
    import ddt.view.PropItemView;
    import flash.display.Bitmap;
    import com.pickgliss.utils.ObjectUtils;

    public class CellContentCreator extends Sprite implements Disposeable 
    {

        private var _factory:ILayerFactory;
        private var _loader:ILayer;
        private var _callBack:Function;
        private var _timer:Timer;
        private var _info:ItemTemplateInfo;
        private var _w:Number;
        private var _h:Number;

        public function CellContentCreator()
        {
            this._factory = LayerFactory.instance;
        }

        public function set info(_arg_1:ItemTemplateInfo):void
        {
            this._info = _arg_1;
        }

        public function get info():ItemTemplateInfo
        {
            return (this._info);
        }

        public function loadSync(_arg_1:Function):void
        {
            var _local_2:String;
            this._callBack = _arg_1;
            if (this._info.CategoryID == EquipType.FRIGHTPROP)
            {
                this._timer = new Timer(50, 1);
                this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                this._timer.start();
            }
            else
            {
                if ((this._info is InventoryItemInfo))
                {
                    _local_2 = ((InventoryItemInfo(this._info).Color == null) ? "" : InventoryItemInfo(this._info).Color);
                    this._loader = this._factory.createLayer(this._info, (this._info.NeedSex == 1), _local_2, BaseLayer.ICON);
                }
                else
                {
                    this._loader = this._factory.createLayer(this._info, (this._info.NeedSex == 1), "", BaseLayer.ICON);
                };
                this._loader.load(this.loadComplete);
            };
        }

        public function clearLoader():void
        {
            if (this._loader != null)
            {
                this._loader.dispose();
                this._loader = null;
            };
        }

        private function __timerComplete(_arg_1:TimerEvent):void
        {
            if (this._timer)
            {
                this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                this._timer.stop();
            };
            addChild((PropItemView.createView(this._info.Pic) as Bitmap));
            this._callBack();
        }

        private function loadComplete(_arg_1:ILayer):void
        {
            addChild(_arg_1.getContent());
            this._callBack();
        }

        public function setColor(_arg_1:*):Boolean
        {
            if (this._loader != null)
            {
                return (this._loader.setColor(_arg_1));
            };
            return (false);
        }

        public function get editLayer():int
        {
            if (this._loader == null)
            {
                return (1);
            };
            return (this._loader.currentEdit);
        }

        override public function set width(_arg_1:Number):void
        {
            super.width = _arg_1;
            this._w = _arg_1;
        }

        override public function set height(_arg_1:Number):void
        {
            super.height = _arg_1;
            this._h = _arg_1;
        }

        public function dispose():void
        {
            this._factory = null;
            if (this._loader != null)
            {
                this._loader.dispose();
            };
            this._loader = null;
            if (this._timer != null)
            {
                this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerComplete);
                this._timer.stop();
                this._timer = null;
            };
            this._callBack = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package bagAndInfo.cell

