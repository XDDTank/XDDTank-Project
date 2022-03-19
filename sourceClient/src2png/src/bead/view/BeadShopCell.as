// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadShopCell

package bead.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import flash.utils.setTimeout;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import bead.BeadManager;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.utils.ObjectUtils;

    public class BeadShopCell extends Sprite implements Disposeable 
    {

        private var _bg:Image;
        private var _line:ScaleBitmapImage;
        private var _exchangeBtn:TextButton;
        private var _nameTxt:FilterFrameText;
        private var _descTxt:FilterFrameText;
        private var _requestScoreTxt:FilterFrameText;
        private var _beadMc:MovieClip;
        private var _itemObj:Object;

        public function BeadShopCell()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("bead.scoreShop.itemBg");
            this._line = ComponentFactory.Instance.creatComponentByStylename("asset.beadSystem.shopLine");
            this._exchangeBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.exchangeBtn");
            this._exchangeBtn.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.cell.nameTxt");
            this._descTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.cell.descTxt");
            this._requestScoreTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.scoreShop.cell.requestScoreTxt");
            addChild(this._bg);
            addChild(this._line);
            addChild(this._exchangeBtn);
            addChild(this._nameTxt);
            addChild(this._descTxt);
            addChild(this._requestScoreTxt);
        }

        private function initEvent():void
        {
            this._exchangeBtn.addEventListener(MouseEvent.CLICK, this.exchangeHandler, false, 0, true);
        }

        private function exchangeHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            SocketManager.Instance.out.sendBeadExchangeBead(this._itemObj.id);
            this._exchangeBtn.enable = false;
            setTimeout(this.enableExchangeBtn, 500);
        }

        private function enableExchangeBtn():void
        {
            if (this._exchangeBtn)
            {
                this._exchangeBtn.enable = true;
            };
        }

        public function show(_arg_1:Object):void
        {
            var _local_2:ItemTemplateInfo;
            var _local_3:InventoryItemInfo;
            this.disposeBeadPic();
            this._itemObj = _arg_1;
            if (this._itemObj)
            {
                this.visible = true;
                _local_2 = ItemManager.Instance.getTemplateById(this._itemObj.id);
                this.createBeadPic(_local_2);
                _local_3 = new InventoryItemInfo();
                _local_3.Property2 = _local_2.Property2;
                _local_3.Property3 = _local_2.Property3;
                _local_3.Property5 = _local_2.Property5;
                _local_3.Name = _local_2.Name;
                _local_3.beadLevel = 1;
                this._nameTxt.htmlText = BeadManager.instance.getBeadColorName(_local_3, false);
                this._descTxt.htmlText = BeadManager.instance.getDescriptionStr(_local_3);
                this._requestScoreTxt.text = (_arg_1.score + LanguageMgr.GetTranslation("tank.gameover.takecard.score"));
            }
            else
            {
                this.visible = false;
            };
        }

        private function createBeadPic(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:Scale9CornerImage;
            if (((int(_arg_1.Property2) < 0) || (int(_arg_1.Property2) > 10)))
            {
                return;
            };
            _local_2 = ComponentFactory.Instance.creatComponentByStylename("asset.beadSystem.beadInset.cellBG");
            this._beadMc = ClassUtils.CreatInstance(("asset.beadSystem.typeBead" + _arg_1.Property2));
            this._beadMc.gotoAndPlay(1);
            this._beadMc.scaleX = (52 / 78);
            this._beadMc.scaleY = (52 / 78);
            this._beadMc.x = 10;
            this._beadMc.y = 15;
            _local_2.x = 5;
            _local_2.y = 10;
            addChild(_local_2);
            addChild(this._beadMc);
        }

        private function removeEvent():void
        {
            this._exchangeBtn.addEventListener(MouseEvent.CLICK, this.exchangeHandler);
        }

        private function disposeBeadPic():void
        {
            if (this._beadMc)
            {
                this._beadMc.gotoAndStop(this._beadMc.totalFrames);
                ObjectUtils.disposeObject(this._beadMc);
                this._beadMc = null;
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            this.disposeBeadPic();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            if (this._line)
            {
                ObjectUtils.disposeObject(this._line);
            };
            this._bg = null;
            this._line = null;
            if (this._exchangeBtn)
            {
                ObjectUtils.disposeObject(this._exchangeBtn);
            };
            this._exchangeBtn = null;
            if (this._nameTxt)
            {
                ObjectUtils.disposeObject(this._nameTxt);
            };
            this._nameTxt = null;
            if (this._descTxt)
            {
                ObjectUtils.disposeObject(this._descTxt);
            };
            this._descTxt = null;
            if (this._requestScoreTxt)
            {
                ObjectUtils.disposeObject(this._requestScoreTxt);
            };
            this._requestScoreTxt = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package bead.view

