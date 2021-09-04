package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.info.MoneyInfoView;
   import baglocked.BagLockedController;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.IconButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.Price;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.ColorEditor;
   import ddt.view.character.RoomCharacter;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class ShopLeftViewPropCollection
   {
      
      public static const PLAYER_MAX_EQUIP_CNT:uint = 8;
       
      
      public var _btnBg:Scale9CornerImage;
      
      public var btnClearLastEquip:BaseButton;
      
      public var cartList:VBox;
      
      public var cartScroll:ScrollPanel;
      
      public var cbHideGlasses:SelectedCheckButton;
      
      public var cbHideHat:SelectedCheckButton;
      
      public var cbHideSuit:SelectedCheckButton;
      
      public var cbHideWings:SelectedCheckButton;
      
      public var colorEditor:ColorEditor;
      
      public var dressView:Sprite;
      
      public var femaleCharacter:RoomCharacter;
      
      public var infoBg:Bitmap;
      
      public var lastItem:ShopPlayerCell;
      
      public var maleCharacter:RoomCharacter;
      
      public var middlePanelBg:ScaleFrameImage;
      
      public var leftMoneyPanelBuyBtn:BaseButton;
      
      public var muteLock:Boolean;
      
      public var panelBtnGroup:SelectedButtonGroup;
      
      public var panelCartBtn:SelectedTextButton;
      
      public var panelColorBtn:SelectedTextButton;
      
      public var playerCells:Vector.<ShopPlayerCell>;
      
      public var playerMoneyView:MoneyInfoView;
      
      public var playerGiftView:MoneyInfoView;
      
      public var presentBtn:BaseButton;
      
      public var purchaseBtn:IconButton;
      
      public var checkOutPanel:ShopCheckOutView;
      
      public var saveFigureBtn:BaseButton;
      
      public var addedManNewEquip:int = 0;
      
      public var addedWomanNewEquip:int = 0;
      
      public var purchaseView:Sprite;
      
      public var adjustColorView:Sprite;
      
      public var presentEffet:IEffect;
      
      public var purchaseEffet:IEffect;
      
      public var saveFigureEffet:IEffect;
      
      public var colorEffet:IEffect;
      
      public var canShine:Boolean;
      
      public var bagLockedController:BagLockedController;
      
      public var randomBtn:TextButton;
      
      private var playerNameText:FilterFrameText;
      
      private var rankingLabelText:FilterFrameText;
      
      private var rankingText:FilterFrameText;
      
      public function ShopLeftViewPropCollection()
      {
         super();
      }
      
      public function setup() : void
      {
         var _loc2_:ShopPlayerCell = null;
         this.panelBtnGroup = new SelectedButtonGroup();
         this.playerCells = new Vector.<ShopPlayerCell>();
         this.dressView = new Sprite();
         this.dressView.x = 1;
         this.dressView.y = -1;
         this.purchaseView = new Sprite();
         this.adjustColorView = new Sprite();
         this.lastItem = CellFactory.instance.createShopColorItemCell() as ShopPlayerCell;
         this.infoBg = ComponentFactory.Instance.creatBitmap("ddtshop.BodyInfoBg");
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.leftViewProBtnBg");
         this.playerNameText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PlayerNameText");
         this.playerNameText.text = PlayerManager.Instance.Self.NickName;
         this.rankingLabelText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RankingLabelText");
         this.rankingLabelText.text = LanguageMgr.GetTranslation("shop.ShopLeftView.BodyInfo.RankingtLabel");
         this.rankingText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.RankingText");
         this.rankingText.text = PlayerManager.Instance.Self.Repute.toString();
         this.middlePanelBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.LeftMiddlePanelBg");
         this.leftMoneyPanelBuyBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.LeftMoneyPanelBuyBtn");
         this.saveFigureBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnSaveFigure");
         this.presentBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnPresent");
         this.purchaseBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnPurchase");
         this.panelCartBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnCartPanel");
         this.panelCartBtn.text = LanguageMgr.GetTranslation("shop.ShopLeftView.CartPaneText");
         this.panelColorBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnColorPanel");
         this.panelColorBtn.text = LanguageMgr.GetTranslation("shop.ShopLeftView.ColorPaneText");
         this.btnClearLastEquip = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnClearLastEquip");
         this.btnClearLastEquip.tipData = LanguageMgr.GetTranslation("");
         this.playerMoneyView = new MoneyInfoView(Price.MONEY);
         PositionUtils.setPos(this.playerMoneyView,"ddtshop.playerMoneyTxtPos");
         this.playerGiftView = new MoneyInfoView(Price.DDT_MONEY);
         PositionUtils.setPos(this.playerGiftView,"ddtshop.playerGiftTxtPos");
         this.cartScroll = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemList");
         this.cartList = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CartItemContainer");
         this.cbHideGlasses = ComponentFactory.Instance.creatComponentByStylename("ddtshop.HideGlassesCb");
         this.cbHideHat = ComponentFactory.Instance.creatComponentByStylename("ddtshop.HideHatCb");
         this.cbHideSuit = ComponentFactory.Instance.creatComponentByStylename("ddtshop.HideSuitCb");
         this.cbHideWings = ComponentFactory.Instance.creatComponentByStylename("ddtshop.HideWingsCb");
         this.colorEditor = ComponentFactory.Instance.creatCustomObject("ddtshop.ColorEdit");
         this.checkOutPanel = ComponentFactory.Instance.creatCustomObject("ddtshop.CheckOutView");
         this.presentEffet = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this.presentBtn);
         this.purchaseEffet = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this.purchaseBtn,{"color":EffectColorType.GOLD});
         this.saveFigureEffet = EffectManager.Instance.creatEffect(EffectTypes.SHINER_ANIMATION,this.saveFigureBtn,{"color":EffectColorType.GOLD});
         this.bagLockedController = new BagLockedController();
         this.btnClearLastEquip.tipData = LanguageMgr.GetTranslation("shop.ShopLeftView.BodyInfo.LastEquipTipText");
         this.muteLock = false;
         this.middlePanelBg.setFrame(1);
         this.cartScroll.vScrollProxy = ScrollPanel.ON;
         this.cartScroll.setView(this.cartList);
         this.cartScroll.invalidateViewport(true);
         this.cartScroll.vUnitIncrement = 15;
         this.cartScroll.visible = false;
         this.cartList.strictSize = 66;
         this.cartList.isReverAdd = true;
         this.panelBtnGroup.addSelectItem(this.panelCartBtn);
         this.panelBtnGroup.addSelectItem(this.panelColorBtn);
         this.panelCartBtn.displacement = this.panelColorBtn.displacement = false;
         this.panelBtnGroup.selectIndex = 0;
         this.saveFigureBtn.enable = false;
         this.presentBtn.enable = false;
         this.purchaseBtn.enable = false;
         this.panelColorBtn.enable = false;
         this.leftMoneyPanelBuyBtn.enable = false;
         this.playerMoneyView.setInfo(PlayerManager.Instance.Self);
         this.playerGiftView.setInfo(PlayerManager.Instance.Self);
         this.colorEditor.visible = false;
         this.colorEditor.restorable = false;
         this.lastItem.visible = false;
         PositionUtils.setPos(this.lastItem,"ddtshop.LastItemPos");
         this.canShine = true;
         this.dressView.addChild(this.infoBg);
         this.dressView.addChild(this.saveFigureBtn);
         this.dressView.addChild(this.btnClearLastEquip);
         this.dressView.addChild(this.cbHideGlasses);
         this.dressView.addChild(this.cbHideHat);
         this.dressView.addChild(this.cbHideSuit);
         this.dressView.addChild(this.cbHideWings);
         this.purchaseView.addChild(this.playerMoneyView);
         this.purchaseView.addChild(this.playerGiftView);
         this.purchaseView.addChild(this.leftMoneyPanelBuyBtn);
         var _loc1_:int = 0;
         while(_loc1_ < PLAYER_MAX_EQUIP_CNT)
         {
            _loc2_ = CellFactory.instance.createShopPlayerItemCell() as ShopPlayerCell;
            PositionUtils.setPos(_loc2_,"ddtshop.PlayerCellPos_" + String(_loc1_));
            this.playerCells.push(_loc2_);
            this.dressView.addChild(_loc2_);
            _loc1_++;
         }
         this.randomBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.BtnRandom");
         this.randomBtn.text = LanguageMgr.GetTranslation("shop.ShopLeftView.BodyInfo.RandomBtnText");
         this.randomBtn.tipData = LanguageMgr.GetTranslation("shop.ShopLeftView.BodyInfo.RandomBtnTipText");
      }
      
      public function addChildrenTo(param1:DisplayObjectContainer) : void
      {
         param1.addChild(this.middlePanelBg);
         param1.addChild(this._btnBg);
         param1.addChild(this.presentBtn);
         param1.addChild(this.purchaseBtn);
         param1.addChild(this.panelCartBtn);
         param1.addChild(this.panelColorBtn);
         param1.addChild(this.dressView);
         param1.addChild(this.colorEditor);
         param1.addChild(this.purchaseView);
         param1.addChild(this.cartScroll);
         param1.addChild(this.lastItem);
         param1.addChild(this.randomBtn);
         param1.addChild(this.playerNameText);
         param1.addChild(this.rankingLabelText);
         param1.addChild(this.rankingText);
      }
      
      public function disposeAllChildrenFrom(param1:DisplayObjectContainer) : void
      {
         EffectManager.Instance.removeEffect(this.presentEffet);
         EffectManager.Instance.removeEffect(this.purchaseEffet);
         EffectManager.Instance.removeEffect(this.saveFigureEffet);
         ObjectUtils.disposeAllChildren(this.colorEditor);
         ObjectUtils.disposeAllChildren(this.dressView);
         ObjectUtils.disposeAllChildren(this.purchaseView);
         ObjectUtils.disposeAllChildren(param1);
         this.panelBtnGroup.dispose();
         this.panelBtnGroup = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.playerCells.length)
         {
            this.playerCells[_loc2_] = null;
            _loc2_++;
         }
         this.dressView = null;
         this.purchaseView = null;
         param1 = null;
         this.playerCells = null;
         this.dressView = null;
         this.lastItem = null;
         this.infoBg = null;
         this.middlePanelBg = null;
         this.leftMoneyPanelBuyBtn = null;
         this.saveFigureBtn = null;
         this.presentBtn = null;
         this.purchaseBtn = null;
         this.panelCartBtn = null;
         this.panelColorBtn = null;
         this.btnClearLastEquip = null;
         this.cartScroll = null;
         this.cartList = null;
         this.cbHideGlasses = null;
         this.cbHideHat = null;
         this.cbHideSuit = null;
         this.colorEditor = null;
         this.randomBtn = null;
         this.bagLockedController.close();
         this.bagLockedController = null;
      }
   }
}
