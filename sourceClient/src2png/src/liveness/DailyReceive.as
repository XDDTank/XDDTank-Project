// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//liveness.DailyReceive

package liveness
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.container.VBox;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.comm.PackageIn;
    import ddt.manager.PlayerManager;
    import flash.events.Event;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.geom.Point;
    import ddt.manager.ItemManager;
    import ddt.manager.DropGoodsManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class DailyReceive extends Frame 
    {

        private var _bg:Scale9CornerImage;
        private var _itemBox:VBox;
        private var _dailyItem:Vector.<DailyReceiveItem>;

        public function DailyReceive()
        {
            escEnable = false;
            this.initView();
            this.initEvent();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("liveness.frame.dailyReceive.bg");
            addToContent(this._bg);
            this._itemBox = ComponentFactory.Instance.creatComponentByStylename("ddthall.dailyReceive.itemBox");
            addToContent(this._itemBox);
            titleText = LanguageMgr.GetTranslation("ddt.liveness.dailyReceive.Title");
            this.initDailyItem();
        }

        private function initDailyItem():void
        {
            var _local_2:DailyReceiveItem;
            this._dailyItem = new Vector.<DailyReceiveItem>();
            var _local_1:int = 1;
            while (_local_1 < 8)
            {
                _local_2 = new DailyReceiveItem(_local_1);
                this._dailyItem.push(_local_2);
                this._itemBox.addChild(_local_2);
                _local_1++;
            };
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__resposeHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_AWARD, this.__dailyAward);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__resposeHandler);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DAILY_AWARD, this.__dailyAward);
        }

        private function __dailyAward(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Boolean = _local_2.readBoolean();
            if (_local_3)
            {
                this.dispose();
                this.dropGoods();
                PlayerManager.Instance.Self.isAward = true;
                DailyReceiveManager.Instance.dispatchEvent(new Event(DailyReceiveManager.CLOSE_ICON));
            };
        }

        private function dropGoods():void
        {
            var _local_5:ItemTemplateInfo;
            var _local_6:Point;
            var _local_1:Array = new Array();
            var _local_2:Array = DailyReceiveManager.Instance.getByDayTemplateId(PlayerManager.Instance.Self.awardLog);
            var _local_3:Array = DailyReceiveManager.Instance.getByGradeAwards(_local_2);
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                _local_5 = ItemManager.Instance.getTemplateById(_local_3[_local_4].TemplateID);
                _local_1.push(_local_5);
                _local_4++;
            };
            if (_local_1.length > 0)
            {
                _local_6 = new Point(500, 300);
                DropGoodsManager.play(_local_1, _local_6);
            };
        }

        private function __resposeHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.ESC_CLICK) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._itemBox)
            {
                ObjectUtils.disposeObject(this._itemBox);
            };
            this._itemBox = null;
            super.dispose();
        }


    }
}//package liveness

