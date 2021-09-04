package bead.view
{
   import baglocked.BaglockedManager;
   import bead.BeadManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
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
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
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
      
      private function initEvent() : void
      {
         this._exchangeBtn.addEventListener(MouseEvent.CLICK,this.exchangeHandler,false,0,true);
      }
      
      private function exchangeHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SocketManager.Instance.out.sendBeadExchangeBead(this._itemObj.id);
         this._exchangeBtn.enable = false;
         setTimeout(this.enableExchangeBtn,500);
      }
      
      private function enableExchangeBtn() : void
      {
         if(this._exchangeBtn)
         {
            this._exchangeBtn.enable = true;
         }
      }
      
      public function show(param1:Object) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:InventoryItemInfo = null;
         this.disposeBeadPic();
         this._itemObj = param1;
         if(this._itemObj)
         {
            this.visible = true;
            _loc2_ = ItemManager.Instance.getTemplateById(this._itemObj.id);
            this.createBeadPic(_loc2_);
            _loc3_ = new InventoryItemInfo();
            _loc3_.Property2 = _loc2_.Property2;
            _loc3_.Property3 = _loc2_.Property3;
            _loc3_.Property5 = _loc2_.Property5;
            _loc3_.Name = _loc2_.Name;
            _loc3_.beadLevel = 1;
            this._nameTxt.htmlText = BeadManager.instance.getBeadColorName(_loc3_,false);
            this._descTxt.htmlText = BeadManager.instance.getDescriptionStr(_loc3_);
            this._requestScoreTxt.text = param1.score + LanguageMgr.GetTranslation("tank.gameover.takecard.score");
         }
         else
         {
            this.visible = false;
         }
      }
      
      private function createBeadPic(param1:ItemTemplateInfo) : void
      {
         var _loc2_:Scale9CornerImage = null;
         if(int(param1.Property2) < 0 || int(param1.Property2) > 10)
         {
            return;
         }
         _loc2_ = ComponentFactory.Instance.creatComponentByStylename("asset.beadSystem.beadInset.cellBG");
         this._beadMc = ClassUtils.CreatInstance("asset.beadSystem.typeBead" + param1.Property2);
         this._beadMc.gotoAndPlay(1);
         this._beadMc.scaleX = 52 / 78;
         this._beadMc.scaleY = 52 / 78;
         this._beadMc.x = 10;
         this._beadMc.y = 15;
         _loc2_.x = 5;
         _loc2_.y = 10;
         addChild(_loc2_);
         addChild(this._beadMc);
      }
      
      private function removeEvent() : void
      {
         this._exchangeBtn.addEventListener(MouseEvent.CLICK,this.exchangeHandler);
      }
      
      private function disposeBeadPic() : void
      {
         if(this._beadMc)
         {
            this._beadMc.gotoAndStop(this._beadMc.totalFrames);
            ObjectUtils.disposeObject(this._beadMc);
            this._beadMc = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.disposeBeadPic();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         if(this._line)
         {
            ObjectUtils.disposeObject(this._line);
         }
         this._bg = null;
         this._line = null;
         if(this._exchangeBtn)
         {
            ObjectUtils.disposeObject(this._exchangeBtn);
         }
         this._exchangeBtn = null;
         if(this._nameTxt)
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(this._descTxt)
         {
            ObjectUtils.disposeObject(this._descTxt);
         }
         this._descTxt = null;
         if(this._requestScoreTxt)
         {
            ObjectUtils.disposeObject(this._requestScoreTxt);
         }
         this._requestScoreTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
