// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.command.OpenAllFrame

package ddt.command
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import bagAndInfo.cell.BaseCell;
    import ddt.data.goods.InventoryItemInfo;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Sprite;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.SoundManager;
    import ddt.data.EquipType;
    import ddt.manager.SocketManager;

    public class OpenAllFrame extends BaseAlerFrame 
    {

        private var _number:NumberSelecter;
        private var _cell:BaseCell;
        private var _itemInfo:InventoryItemInfo;
        private var _bg:Image;

        public function OpenAllFrame()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.showSubmit = true;
            _local_1.showCancel = false;
            _local_1.title = LanguageMgr.GetTranslation("ddt.bagCell.openAll");
            info = _local_1;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
            addToContent(this._bg);
            this._number = ComponentFactory.Instance.creatCustomObject("openAllFrame.numberSelecter");
            addToContent(this._number);
            var _local_2:Sprite = new Sprite();
            _local_2.addChild(ComponentFactory.Instance.creatBitmap("asset.ddtcore.EquipCellBG"));
            this._cell = new BaseCell(_local_2);
            this._cell.x = (this._bg.x + 4);
            this._cell.y = (this._bg.y + 4);
            addToContent(this._cell);
            this._cell.tipDirctions = "7,0";
        }

        private function initEvents():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
            this._number.addEventListener(NumberSelecter.NUMBER_CLOSE, this.__numberClose);
        }

        private function __numberClose(_arg_1:Event):void
        {
            ObjectUtils.disposeObject(this);
        }

        private function removeEvnets():void
        {
            this._number.removeEventListener(NumberSelecter.NUMBER_CLOSE, this.__numberClose);
            removeEventListener(FrameEvent.RESPONSE, this.__response);
        }

        public function set ItemInfo(_arg_1:ItemTemplateInfo):void
        {
            this._itemInfo = (_arg_1 as InventoryItemInfo);
            this._cell.info = _arg_1;
            var _local_2:int = ((this._itemInfo.Count > 99) ? 99 : this._itemInfo.Count);
            this.maxLimit = _local_2;
            this._number.number = _local_2;
        }

        public function set maxLimit(_arg_1:int):void
        {
            this._number.maximum = _arg_1;
        }

        private function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (EquipType.isCard(this._itemInfo))
                {
                    SocketManager.Instance.out.sendUseCard(this._itemInfo.BagType, this._itemInfo.Place, [this._itemInfo.TemplateID], this._itemInfo.PayType, false, this._number.number);
                }
                else
                {
                    SocketManager.Instance.out.sendItemOpenUp(this._itemInfo.BagType, this._itemInfo.Place, this._number.number);
                };
            };
            ObjectUtils.disposeObject(this);
        }

        override public function dispose():void
        {
            this.removeEvnets();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._number);
            this._number = null;
            ObjectUtils.disposeObject(this._cell);
            this._cell = null;
            this._itemInfo = null;
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.command

