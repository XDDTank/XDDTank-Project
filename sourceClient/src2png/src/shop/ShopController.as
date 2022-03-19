// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.ShopController

package shop
{
    import ddt.states.BaseStateView;
    import shop.view.ShopLeftView;
    import flash.display.Sprite;
    import shop.view.ShopRightView;
    import shop.view.ShopRankingView;
    import ddt.data.goods.ShopItemInfo;
    import ddt.data.goods.ShopCarItemInfo;
    import ddt.data.EquipType;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.view.MainToolBar;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatBugleView;
    import ddt.manager.PlayerManager;
    import ddt.data.player.PlayerState;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.states.StateType;
    import flash.display.DisplayObject;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.QQtipsManager;

    public class ShopController extends BaseStateView 
    {

        private var _leftView:ShopLeftView;
        private var _view:Sprite;
        private var _model:ShopModel;
        private var _rightView:ShopRightView;
        private var _rankingView:ShopRankingView;


        public function get leftView():ShopLeftView
        {
            return (this._leftView);
        }

        public function get rightView():ShopRightView
        {
            return (this._rightView);
        }

        public function get rankingView():ShopRankingView
        {
            return (this._rankingView);
        }

        public function addTempEquip(_arg_1:ShopItemInfo):Boolean
        {
            var _local_2:Boolean = this._model.addTempEquip(_arg_1);
            this.showPanel(ShopLeftView.SHOW_DRESS);
            return (_local_2);
        }

        public function addToCar(_arg_1:ShopCarItemInfo):Boolean
        {
            this._model.addToShoppingCar(_arg_1);
            if (this._model.isCarListMax())
            {
                return (false);
            };
            return (true);
        }

        public function buyItems(_arg_1:Array, _arg_2:Boolean, _arg_3:String=""):void
        {
            var _local_12:ShopCarItemInfo;
            var _local_4:Array = new Array();
            var _local_5:Array = new Array();
            var _local_6:Array = new Array();
            var _local_7:Array = new Array();
            var _local_8:Array = new Array();
            var _local_9:Array = [];
            var _local_10:Array = [];
            var _local_11:int;
            while (_local_11 < _arg_1.length)
            {
                _local_12 = _arg_1[_local_11];
                _local_4.push(_local_12.GoodsID);
                _local_5.push(_local_12.currentBuyType);
                _local_6.push(_local_12.Color);
                _local_8.push(_local_12.place);
                if (_local_12.CategoryID == EquipType.FACE)
                {
                    _local_9.push(_local_12.skin);
                }
                else
                {
                    _local_9.push("");
                };
                _local_7.push(((_arg_2) ? _local_12.dressing : false));
                _local_10.push(_local_12.isDiscount);
                _local_11++;
            };
            SocketManager.Instance.out.sendBuyGoods(_local_4, _local_5, _local_6, _local_8, _local_7, _local_9, 0, _local_10);
        }

        override public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this._view);
            this._model = null;
            this._leftView = null;
            this._rightView = null;
            this._rankingView = null;
            MainToolBar.Instance.hide();
        }

        override public function enter(_arg_1:BaseStateView, _arg_2:Object=null):void
        {
            super.enter(_arg_1);
            SocketManager.Instance.out.sendCurrentState(1);
            SocketManager.Instance.out.sendUpdateGoodsCount();
            ChatManager.Instance.state = ChatManager.CHAT_SHOP_STATE;
            ChatBugleView.instance.hide();
            PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.SHOPPING, PlayerState.AUTO);
            SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
            this.init();
            StageReferance.stage.focus = StageReferance.stage;
        }

        override public function getBackType():String
        {
            return (StateType.MAIN);
        }

        override public function getType():String
        {
            return (StateType.SHOP);
        }

        override public function getView():DisplayObject
        {
            return (this._view);
        }

        override public function leaving(_arg_1:BaseStateView):void
        {
            this.dispose();
            PlayerManager.Instance.Self.Bag.unLockAll();
            PlayerManager.Instance.Self.playerState = new PlayerState(PlayerState.ONLINE, PlayerState.AUTO);
            SocketManager.Instance.out.sendFriendState(PlayerManager.Instance.Self.playerState.StateID);
            super.leaving(_arg_1);
        }

        public function loadList():void
        {
        }

        public function get model():ShopModel
        {
            return (this._model);
        }

        public function presentItems(_arg_1:Array, _arg_2:String, _arg_3:String):void
        {
            var _local_10:ShopCarItemInfo;
            var _local_4:Array = new Array();
            var _local_5:Array = new Array();
            var _local_6:Array = new Array();
            var _local_7:Array = [];
            var _local_8:Array = new Array();
            var _local_9:int;
            while (_local_9 < _arg_1.length)
            {
                _local_10 = _arg_1[_local_9];
                _local_4.push(_local_10.GoodsID);
                _local_5.push(_local_10.currentBuyType);
                _local_6.push(_local_10.Color);
                if (_local_10.CategoryID == EquipType.FACE)
                {
                    _local_7.push(this._model.currentModel.Skin);
                }
                else
                {
                    _local_7.push("");
                };
                _local_8.push(_local_10.isDiscount);
                _local_9++;
            };
            SocketManager.Instance.out.sendPresentGoods(_local_4, _local_5, _local_6, _local_8, _arg_2, _arg_3, _local_7);
        }

        public function removeFromCar(_arg_1:ShopCarItemInfo):void
        {
            this._model.removeFromShoppingCar(_arg_1);
            if (((SavePointManager.Instance.isInSavePoint(15)) && (!(TaskManager.instance.isNewHandTaskCompleted(11)))))
            {
                if (this._model.allItemsCount == 0)
                {
                    NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
                };
            };
        }

        public function removeTempEquip(_arg_1:ShopCarItemInfo):void
        {
            this._model.removeTempEquip(_arg_1);
        }

        public function restoreAllItemsOnBody():void
        {
            this._model.restoreAllItemsOnBody();
        }

        public function revertToDefault():void
        {
            this._model.revertToDefalt();
        }

        public function setFittingModel(_arg_1:Boolean):void
        {
            this._rightView.setCurrentSex(((_arg_1) ? 1 : 2));
            this._rightView.loadList();
            this._model.fittingSex = _arg_1;
            this._leftView.hideLight();
            this._leftView.adjustUpperView(ShopLeftView.SHOW_DRESS);
            this._leftView.refreshCharater();
        }

        public function setSelectedEquip(_arg_1:ShopCarItemInfo):void
        {
            this._model.setSelectedEquip(_arg_1);
        }

        public function showPanel(_arg_1:uint):void
        {
            this._leftView.adjustUpperView(_arg_1);
        }

        public function updateCost():void
        {
            this._model.updateCost();
        }

        private function init():void
        {
            this._model = new ShopModel();
            this._view = new Sprite();
            this._rightView = ComponentFactory.Instance.creatCustomObject("ddtshop.RightView");
            this._leftView = ComponentFactory.Instance.creatCustomObject("ddtshop.LeftView");
            this._rightView.setup(this);
            this._leftView.setup(this, this._model);
            this._view.addChild(this._leftView);
            this._view.addChild(this._rightView);
            MainToolBar.Instance.show();
            MainToolBar.Instance.setShopState();
            if (QQtipsManager.instance.isGotoShop)
            {
                QQtipsManager.instance.isGotoShop = false;
                this._rightView.gotoPage(ShopRightView.TOP_RECOMMEND, (QQtipsManager.instance.indexCurrentShop - 1));
            }
            else
            {
                this._rightView.gotoPage(ShopRightView.TOP_TYPE, ShopRightView.SUB_TYPE, ShopRightView.CURRENT_PAGE, ShopRightView.CURRENT_GENDER);
            };
            this._rankingView = ComponentFactory.Instance.creatCustomObject("ddtshop.RankingView");
            this._rankingView.setup(this);
            this._view.addChild(this._rankingView);
        }


    }
}//package shop

