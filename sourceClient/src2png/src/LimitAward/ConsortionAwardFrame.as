// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//LimitAward.ConsortionAwardFrame

package LimitAward
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.BuffInfo;
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.manager.LanguageMgr;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ItemManager;
    import ddt.data.EquipType;
    import ddt.manager.TimeManager;
    import consortion.ConosrtionTimerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ConsortionAwardFrame extends Frame 
    {

        private var _itemBg:Scale9CornerImage;
        private var _goodItemBg:Scale9CornerImage;
        private var _cellBg:Scale9CornerImage;
        private var _itemCell:BaseCell;
        private var _decTxt:FilterFrameText;
        private var _itemNameTxt:FilterFrameText;
        private var _buffinfo:BuffInfo;
        private var _receiveBtn:BaseButton;

        public function ConsortionAwardFrame()
        {
            this.initView();
            this.initEvent();
            escEnable = true;
        }

        public static function transformFormatDateTime(_arg_1:Number):String
        {
            var _local_2:Date = new Date(_arg_1);
            _local_2.seconds = (_local_2.minutes = (_local_2.hours = 0));
            var _local_3:Number = (_local_2.time + _arg_1);
            var _local_4:String = String(new Date(_local_3));
            return (_local_4.split(" ")[3]);
        }


        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("tank.timeBox.awardsInfo");
            this._buffinfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.GET_ONLINE_REWARS];
            this._itemBg = ComponentFactory.Instance.creatComponentByStylename("Consortion.GetAwardsItemBG");
            this._goodItemBg = ComponentFactory.Instance.creatComponentByStylename("Consortion.GetAwardsGoodBG");
            this._cellBg = ComponentFactory.Instance.creatComponentByStylename("Consortion.GetAwardsItemCellBG");
            this._itemCell = new BaseCell(this._cellBg, ItemManager.Instance.getTemplateById(EquipType.GOLD_BOX));
            this._itemCell.x = 102;
            this._itemCell.y = 117;
            this._itemCell.tipGapV = 10;
            this._itemCell.setContentSize(40, 40);
            var _local_1:String = TimeManager.Instance.formatTimeToString1((ConosrtionTimerManager.Instance.count * 1000), false);
            var _local_2:int = (ConosrtionTimerManager.Instance.count * 1000);
            var _local_3:Array = _local_1.split(":");
            this._decTxt = ComponentFactory.Instance.creatComponentByStylename("ConsortionAwardFrame.decTxt");
            this._receiveBtn = ComponentFactory.Instance.creatComponentByStylename("ConsortionAwardFrame.btn");
            if (_local_2 == 0)
            {
                this._decTxt.text = "你今日累积在线满1小时，可获得以下奖励";
                this._receiveBtn.enable = true;
            }
            else
            {
                this._decTxt.text = LanguageMgr.GetTranslation("ddt.consortionAwardFrame.dec", _local_3[0], _local_3[1]);
                this._receiveBtn.enable = false;
            };
            this._itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("ConsortionAwardFrame.itemNameTxt");
            this._itemNameTxt.text = (this._buffinfo.Value.toString() + "个金币箱");
            addToContent(this._itemBg);
            addToContent(this._goodItemBg);
            addToContent(this._cellBg);
            addToContent(this._itemCell);
            addToContent(this._decTxt);
            addToContent(this._itemNameTxt);
            addToContent(this._receiveBtn);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
            this._receiveBtn.addEventListener(MouseEvent.CLICK, this._mouseClick);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__response);
            this._receiveBtn.removeEventListener(MouseEvent.CLICK, this._mouseClick);
        }

        private function _mouseClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendOnlineReawd();
            this.dispose();
        }

        private function __response(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.ESC_CLICK) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._itemBg = null;
            this._goodItemBg = null;
            this._cellBg = null;
            this._itemCell = null;
            this._itemNameTxt = null;
            this._decTxt = null;
            this._buffinfo = null;
            this._receiveBtn = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package LimitAward

