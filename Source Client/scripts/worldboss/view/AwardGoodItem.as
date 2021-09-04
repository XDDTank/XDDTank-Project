package worldboss.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import shop.view.ShopGoodItem;
   import shop.view.ShopItemCell;
   import worldboss.WorldBossManager;
   
   [Event(name="giving",type="ddt.events.ShopItemEvent")]
   [Event(name="collect",type="ddt.events.ShopItemEvent")]
   [Event(name="purchase",type="ddt.events.ShopItemEvent")]
   public class AwardGoodItem extends ShopGoodItem
   {
      
      private static const AwardItemCell_Size:int = 61;
       
      
      private var _scoreTitleField:FilterFrameText;
      
      private var _scoreField:FilterFrameText;
      
      private var _exchangeBtn:TextButton;
      
      private var _awardItem:Scale9CornerImage;
      
      public function AwardGoodItem()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._scoreTitleField);
         this._scoreTitleField = null;
         ObjectUtils.disposeObject(this._scoreField);
         this._scoreField = null;
         ObjectUtils.disposeObject(this._exchangeBtn);
         this._exchangeBtn = null;
         ObjectUtils.disposeObject(this._awardItem);
         this._exchangeBtn = null;
      }
      
      override protected function initContent() : void
      {
         this._awardItem = ComponentFactory.Instance.creatComponentByStylename("asset.littleGame.background");
         addChild(this._awardItem);
         super.initContent();
         this._exchangeBtn = ComponentFactory.Instance.creatComponentByStylename("core.shop.exchangeButton");
         this._exchangeBtn.text = LanguageMgr.GetTranslation("tank.littlegame.exchange");
         addChild(this._exchangeBtn);
         var _loc1_:Rectangle = ComponentFactory.Instance.creatCustomObject("littleGame.GoodItemBG.size");
         _itemBg.width = _loc1_.width;
         _itemBg.height = _loc1_.height;
         _loc1_ = ComponentFactory.Instance.creatCustomObject("littleGame.GoodItemName.size");
         ObjectUtils.disposeObject(_itemNameTxt);
         _itemNameTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodItemNameII");
         _itemNameTxt.x = _loc1_.x;
         _itemNameTxt.width = _loc1_.width;
         addChild(_itemNameTxt);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("littleGame.GoodItemDotLine.size");
         _dotLine.width = _loc1_.width;
         PositionUtils.setPos(_payType,"littleGame.GoodPayTypeLabel.pos");
         PositionUtils.setPos(_payPaneBuyBtn,"littleGame.PayPaneBuyBtn.pos");
         PositionUtils.setPos(_itemNameTxt,"littleGame.GoodItemName.pos");
         PositionUtils.setPos(_dotLine,"littleGame.GoodItemDotLine.pos");
         PositionUtils.setPos(_itemCellBg,"littleGame.GoodItemCellBg.pos");
         _payPaneGivingBtn.visible = false;
         _payPaneBuyBtn.visible = false;
         this._exchangeBtn.enable = !WorldBossManager.Instance.isOpen;
         _itemBg.visible = false;
         _itemPriceTxt.visible = false;
         _shopItemCellTypeBg.visible = false;
         _payType.visible = false;
         this._scoreTitleField = ComponentFactory.Instance.creatComponentByStylename("littleGame.AwardScoreTitleField");
         this._scoreTitleField.text = LanguageMgr.GetTranslation("littlegame.AwardScore");
         addChild(this._scoreTitleField);
         this._scoreField = ComponentFactory.Instance.creatComponentByStylename("littleGame.AwardScoreField");
         addChild(this._scoreField);
         PositionUtils.setPos(itemCell,"littleGame.GoodItemCell.pos");
         itemCell.cellSize = AwardItemCell_Size;
      }
      
      override protected function creatItemCell() : ShopItemCell
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,AwardItemCell_Size,AwardItemCell_Size);
         _loc1_.graphics.endFill();
         return CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._exchangeBtn.addEventListener(MouseEvent.CLICK,this.__payPanelClick);
         _itemCellBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         _itemCellBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         _itemBg.addEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         _itemBg.addEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      override protected function __itemMouseOver(param1:MouseEvent) : void
      {
         if(!_itemCell.info)
         {
            return;
         }
         if(_lightMc)
         {
            addChild(_lightMc);
         }
         parent.addChild(this);
         _isMouseOver = true;
         __timelineComplete();
      }
      
      override protected function __itemMouseOut(param1:MouseEvent) : void
      {
         ObjectUtils.disposeObject(_lightMc);
         if(!_shopItemInfo)
         {
            return;
         }
         _isMouseOver = false;
         __timelineComplete();
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._exchangeBtn.removeEventListener(MouseEvent.CLICK,this.__payPanelClick);
         _itemCellBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         _itemCellBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
         _itemBg.removeEventListener(MouseEvent.MOUSE_OVER,this.__itemMouseOver);
         _itemBg.removeEventListener(MouseEvent.MOUSE_OUT,this.__itemMouseOut);
      }
      
      override protected function __payPanelClick(param1:MouseEvent) : void
      {
         if(_shopItemInfo == null)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.damageScores < _shopItemInfo.AValue1)
         {
            return MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.littlegame.scorelack"));
         }
         var _loc2_:ExchangeGoodsFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.exchangeFrame");
         _loc2_.setTitleText(LanguageMgr.GetTranslation("ddt.wordBoss.quickExchange"));
         _loc2_.ItemInfo = _shopItemInfo;
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function updata() : void
      {
         this._exchangeBtn.enable = WorldBossManager.Instance.bossInfo.roomClose;
      }
      
      override public function set shopItemInfo(param1:ShopItemInfo) : void
      {
         super.shopItemInfo = param1;
         _payPaneGivingBtn.visible = false;
         _payPaneBuyBtn.visible = false;
         _payType.visible = false;
         this._exchangeBtn.visible = param1 != null;
         _itemPriceTxt.visible = false;
         _shopItemCellTypeBg.visible = false;
         if(param1)
         {
            this._scoreField.visible = true;
            this._scoreTitleField.visible = true;
            this._scoreField.text = String(param1.AValue1);
         }
         else
         {
            this._scoreField.visible = false;
            this._scoreTitleField.visible = false;
         }
      }
   }
}
