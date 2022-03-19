// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestBubble

package quest
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import __AS3__.vec.Vector;
    import flash.utils.Timer;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class QuestBubble extends Component 
    {

        public const ACTISOVER:String = "act_is_over";
        public const SHOWTASKTIP:String = "show_task_tip";
        private const BASEWIDTH:int = 25;

        private var _bg:ScaleBitmapImage;
        private var _itemVec:Vector.<BubbleItem>;
        private var _time:Timer;
        private var _questModeArr:Array;
        private var _regularPos:Point;
        private var _basePos:Point;


        public function start(_arg_1:Array):void
        {
            this._questModeArr = _arg_1;
        }

        public function show():void
        {
            super.init();
            this._itemVec = new Vector.<BubbleItem>();
            this._bg = ComponentFactory.Instance.creatComponentByStylename("toolbar.bubbleBg");
            this._regularPos = ComponentFactory.Instance.creatCustomObject("toolbar.bubbleRegularPos");
            this._basePos = ComponentFactory.Instance.creatCustomObject("toolbar.bubbleBasePos");
            addChild(this._bg);
            this._countInfo();
            x = this._regularPos.x;
            y = (this._regularPos.y - this._bg.height);
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, false, LayerManager.NONE_BLOCKGOUND);
        }

        private function _countInfo():void
        {
            var _local_2:BubbleItem;
            var _local_1:int;
            while (_local_1 < this._questModeArr.length)
            {
                _local_2 = new BubbleItem();
                addChild(_local_2);
                _local_2.setTextInfo(this._questModeArr[_local_1].txtI, this._questModeArr[_local_1].txtII, this._questModeArr[_local_1].txtIII);
                _local_2.y = (((_local_2.height * _local_1) * 5) / 4);
                this._itemVec.push(_local_2);
                _local_1++;
            };
            this._bg.height = ((1 + this._itemVec.length) * this.BASEWIDTH);
        }

        override public function dispose():void
        {
            var _local_1:int;
            super.dispose();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            if (this._itemVec != null)
            {
                while (_local_1 < this._itemVec.length)
                {
                    ObjectUtils.disposeObject(this._itemVec[_local_1]);
                    _local_1++;
                };
                this._itemVec = null;
            };
        }


    }
}//package quest

