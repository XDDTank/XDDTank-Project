package shop
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerState;
   import ddt.manager.ChatManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.QQtipsManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TaskManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.chat.ChatBugleView;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import shop.view.ShopLeftView;
   import shop.view.ShopRankingView;
   import shop.view.ShopRightView;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class ShopController extends BaseStateView
   {
       
      
      private var _leftView:ShopLeftView;
      
      private var _view:Sprite;
      
      private var _model:ShopModel;
      
      private var _rightView:ShopRightView;
      
      private var _rankingView:ShopRankingView;
      
      public function ShopController()
      {
         super();
      }
      
      public function get leftView() : ShopLeftView
      {
         return this._leftView;
      }
      
      public function get rightView() : ShopRightView
      {
         return this._rightView;
      }
      
      public function get rankingView() : ShopRankingView
      {
         return this._rankingView;
      }
      
      public function addTempEquip(param1:ShopItemInfo) : Boolean
      {
         var _loc2_:Boolean = this._model.addTempEquip(param1);
         this.showPanel(ShopLeftView.SHOW_DRESS);
         return _loc2_;
      }
      
      public function addToCar(param1:ShopCarItemInfo) : Boolean
      {
         this._model.addToShoppingCar(param1);
         if(this._model.isCarListMax())
         {
            return false;
         }
         return true;
      }
      
      public function buyItems(param1:Array, param2:Boolean, param3:String = "") : void
      {
         var _loc12_:ShopCarItemInfo = null;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         var _loc9_:Array = [];
         var _loc10_:Array = [];
         var _loc11_:int = 0;
         while(_loc11_ < param1.length)
         {
            _loc12_ = param1[_loc11_];
            _loc4_.push(_loc12_.GoodsID);
            _loc5_.push(_loc12_.currentBuyType);
            _loc6_.push(_loc12_.Color);
            _loc8_.push(_loc12_.place);
            if(_loc12_.CategoryID == EquipType.FACE)
            {
               _loc9_.push(_loc12_.skin);
            }
            else
            {
               _loc9_.push("");
            }
            _loc7_.push(!!param2 ? _loc12_.dressing : false);
            _loc10_.push(_loc12_.isDiscount);
            _loc11_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc4_,_loc5_,_loc6_,_loc8_,_loc7_,_loc9_,0,_loc10_);
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this._view);
         this._model = null;
         this._leftView = null;
         this._rightView = null;
         this._rankingView = null;
         MainToolBar.Instance.hide();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1);
         SocketManager.Instance.out.sendCurrentState(1);
         SocketManager.Instance.out.sendUpdateGoodsCount();
         ChatManager.Instance.state = ChatManager.CHAT_SHOP_STATE;
         ChatBugleView.instance.hide();
         PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.SHOPPING,PlayerState.AUTO);
         SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
         this.init();
         StageReferance.stage.focus = StageReferance.stage;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.SHOP;
      }
      
      override public function getView() : DisplayObject
      {
         return this._view;
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.dispose();
         PlayerManager.Instance.Self.Bag.unLockAll();
         PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.ONLINE,PlayerState.AUTO);
         SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
         super.leaving(param1);
      }
      
      public function loadList() : void
      {
      }
      
      public function get model() : ShopModel
      {
         return this._model;
      }
      
      public function presentItems(param1:Array, param2:String, param3:String) : void
      {
         var _loc10_:ShopCarItemInfo = null;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = [];
         var _loc8_:Array = new Array();
         var _loc9_:int = 0;
         while(_loc9_ < param1.length)
         {
            _loc10_ = param1[_loc9_];
            _loc4_.push(_loc10_.GoodsID);
            _loc5_.push(_loc10_.currentBuyType);
            _loc6_.push(_loc10_.Color);
            if(_loc10_.CategoryID == EquipType.FACE)
            {
               _loc7_.push(this._model.currentModel.Skin);
            }
            else
            {
               _loc7_.push("");
            }
            _loc8_.push(_loc10_.isDiscount);
            _loc9_++;
         }
         SocketManager.Instance.out.sendPresentGoods(_loc4_,_loc5_,_loc6_,_loc8_,param2,param3,_loc7_);
      }
      
      public function removeFromCar(param1:ShopCarItemInfo) : void
      {
         this._model.removeFromShoppingCar(param1);
         if(SavePointManager.Instance.isInSavePoint(15) && !TaskManager.instance.isNewHandTaskCompleted(11))
         {
            if(this._model.allItemsCount == 0)
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
            }
         }
      }
      
      public function removeTempEquip(param1:ShopCarItemInfo) : void
      {
         this._model.removeTempEquip(param1);
      }
      
      public function restoreAllItemsOnBody() : void
      {
         this._model.restoreAllItemsOnBody();
      }
      
      public function revertToDefault() : void
      {
         this._model.revertToDefalt();
      }
      
      public function setFittingModel(param1:Boolean) : void
      {
         this._rightView.setCurrentSex(!!param1 ? int(1) : int(2));
         this._rightView.loadList();
         this._model.fittingSex = param1;
         this._leftView.hideLight();
         this._leftView.adjustUpperView(ShopLeftView.SHOW_DRESS);
         this._leftView.refreshCharater();
      }
      
      public function setSelectedEquip(param1:ShopCarItemInfo) : void
      {
         this._model.setSelectedEquip(param1);
      }
      
      public function showPanel(param1:uint) : void
      {
         this._leftView.adjustUpperView(param1);
      }
      
      public function updateCost() : void
      {
         this._model.updateCost();
      }
      
      private function init() : void
      {
         this._model = new ShopModel();
         this._view = new Sprite();
         this._rightView = ComponentFactory.Instance.creatCustomObject("ddtshop.RightView");
         this._leftView = ComponentFactory.Instance.creatCustomObject("ddtshop.LeftView");
         this._rightView.setup(this);
         this._leftView.setup(this,this._model);
         this._view.addChild(this._leftView);
         this._view.addChild(this._rightView);
         MainToolBar.Instance.show();
         MainToolBar.Instance.setShopState();
         if(QQtipsManager.instance.isGotoShop)
         {
            QQtipsManager.instance.isGotoShop = false;
            this._rightView.gotoPage(ShopRightView.TOP_RECOMMEND,QQtipsManager.instance.indexCurrentShop - 1);
         }
         else
         {
            this._rightView.gotoPage(ShopRightView.TOP_TYPE,ShopRightView.SUB_TYPE,ShopRightView.CURRENT_PAGE,ShopRightView.CURRENT_GENDER);
         }
         this._rankingView = ComponentFactory.Instance.creatCustomObject("ddtshop.RankingView");
         this._rankingView.setup(this);
         this._view.addChild(this._rankingView);
      }
   }
}