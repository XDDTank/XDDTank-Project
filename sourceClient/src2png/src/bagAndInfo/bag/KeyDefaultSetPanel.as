// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.KeyDefaultSetPanel

package bagAndInfo.bag
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import flash.events.Event;
    import ddt.manager.SharedManager;
    import ddt.manager.ItemManager;
    import ddt.view.PropItemView;
    import ddt.events.ItemEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;

    public class KeyDefaultSetPanel extends Sprite 
    {

        private var _bg:Bitmap;
        private var alphaClickArea:Sprite;
        private var _icon:Array;
        public var selectedItemID:int = 0;

        public function KeyDefaultSetPanel()
        {
            this.initView();
        }

        private function initView():void
        {
            var _local_5:ItemTemplateInfo;
            var _local_6:KeySetItem;
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.KeySet.KeyTL");
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("bagAndInfo.bag.KeySet.KeyRect");
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.__removeToStage);
            this.alphaClickArea = new Sprite();
            this._bg = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.keySetBGAsset");
            addChild(this._bg);
            this._icon = [];
            var _local_3:Array = SharedManager.KEY_SET_ABLE;
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                _local_5 = ItemManager.Instance.getTemplateById(_local_3[_local_4]);
                if (_local_5)
                {
                    _local_6 = new KeySetItem(_local_3[_local_4], 0, _local_3[_local_4], PropItemView.createView(_local_5.Pic, 40, 40));
                    _local_6.addEventListener(ItemEvent.ITEM_CLICK, this.onItemClick);
                    _local_6.x = (_local_1.x + ((_local_4 < 4) ? (_local_4 * _local_2.x) : ((_local_4 - 4) * _local_2.x)));
                    _local_6.y = (_local_1.y + ((_local_4 < 4) ? 0 : (Math.floor((_local_4 / 4)) * _local_2.y)));
                    _local_6.setClick(true, false, true);
                    _local_6.height = (_local_6.width = 40);
                    _local_6.setBackgroundVisible(false);
                    addChild(_local_6);
                    this._icon.push(_local_6);
                };
                _local_4++;
            };
        }

        private function __addToStage(_arg_1:Event):void
        {
            this.alphaClickArea.graphics.beginFill(0xFF00FF, 0);
            this.alphaClickArea.graphics.drawRect(-3000, -3000, 6000, 6000);
            addChildAt(this.alphaClickArea, 0);
            this.alphaClickArea.addEventListener(MouseEvent.CLICK, this.clickHide);
        }

        private function __removeToStage(_arg_1:Event):void
        {
            this.alphaClickArea.graphics.clear();
            this.alphaClickArea.removeEventListener(MouseEvent.CLICK, this.clickHide);
        }

        private function clickHide(_arg_1:MouseEvent):void
        {
            this.hide();
        }

        public function hide():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function dispose():void
        {
            var _local_1:KeySetItem;
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            removeEventListener(Event.REMOVED_FROM_STAGE, this.__removeToStage);
            while (this._icon.length > 0)
            {
                _local_1 = (this._icon.shift() as KeySetItem);
                if (_local_1)
                {
                    _local_1.removeEventListener(ItemEvent.ITEM_CLICK, this.onItemClick);
                    _local_1.dispose();
                };
                _local_1 = null;
            };
            this._icon = null;
            if (this.alphaClickArea)
            {
                this.alphaClickArea.removeEventListener(MouseEvent.CLICK, this.clickHide);
                this.alphaClickArea.graphics.clear();
                if (this.alphaClickArea.parent)
                {
                    this.alphaClickArea.parent.removeChild(this.alphaClickArea);
                };
            };
            this.alphaClickArea = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function onItemClick(_arg_1:ItemEvent):void
        {
            SoundManager.instance.play("008");
            this.selectedItemID = _arg_1.index;
            this.hide();
            dispatchEvent(new Event(Event.SELECT));
        }


    }
}//package bagAndInfo.bag

