// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.refining.RefiningEquipCell

package store.view.refining
{
    import store.StoreCell;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import bagAndInfo.cell.CellContentCreator;
    import flash.events.Event;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.SoundManager;
    import ddt.data.goods.InventoryItemInfo;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.DragManager;

    public class RefiningEquipCell extends StoreCell 
    {

        public static const CONTENTSIZE:int = 70;

        private var _actionState:Boolean;
        private var _text:FilterFrameText;

        public function RefiningEquipCell()
        {
            var _local_1:Sprite = new Sprite();
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.BlankCellBG");
            _local_1.addChild(_local_2);
            super(_local_1, 1);
            setContentSize(CONTENTSIZE, CONTENTSIZE);
            shinerPos = ComponentFactory.Instance.creatCustomObject("ddtstore.refining.equipCellShinePos");
            this._text = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreRefiningBG.EquipmentCellText");
            this._text.htmlText = LanguageMgr.GetTranslation("store.storeRefiningBG.equipcell.txt");
            addChild(this._text);
        }

        override protected function creatPic():void
        {
            if (((_info) && (((!(_pic)) || (!(_pic.info))) || (!(_info.TemplateID == _pic.info.TemplateID)))))
            {
                ObjectUtils.disposeObject(_pic);
                _pic = null;
                _pic = new CellContentCreator();
                _pic.info = _info;
                _pic.loadSync(createContentComplete);
                addChild(_pic);
            }
            else
            {
                ObjectUtils.disposeObject(_pic);
                _pic = null;
            };
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            super.info = _arg_1;
            tipStyle = "ddtstore.StrengthTips";
            if (_arg_1 == null)
            {
                dispatchEvent(new Event(Event.CHANGE));
            };
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            SoundManager.instance.playButtonSound();
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            _arg_1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            dispatchEvent(new RefiningEvent(RefiningEvent.MOVE, _local_2));
        }

        public function get actionState():Boolean
        {
            return (this._actionState);
        }

        public function set actionState(_arg_1:Boolean):void
        {
            this._actionState = _arg_1;
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._text);
            this._text = null;
            super.dispose();
        }


    }
}//package store.view.refining

