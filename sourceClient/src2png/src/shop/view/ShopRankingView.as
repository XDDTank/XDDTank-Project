// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopRankingView

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import shop.ShopController;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.ShopManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ShopRankingView extends Sprite implements Disposeable 
    {

        private var _controller:ShopController;
        private var _shopSearchBg:Scale9CornerImage;
        private var _shopSearchBtn:BaseButton;
        private var _shopSearchText:FilterFrameText;
        private var _currentShopSearchText:String;
        private var _currentList:Vector.<ShopItemInfo>;


        public function setup(_arg_1:ShopController):void
        {
            this._controller = _arg_1;
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._shopSearchBg = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchBg");
            addChild(this._shopSearchBg);
            this._shopSearchBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchBtn");
            addChild(this._shopSearchBtn);
            this._shopSearchText = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchText");
            this._shopSearchText.text = LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText");
            addChild(this._shopSearchText);
        }

        private function addEvent():void
        {
            this._shopSearchText.addEventListener(FocusEvent.FOCUS_IN, this.__shopSearchTextFousIn);
            this._shopSearchText.addEventListener(FocusEvent.FOCUS_OUT, this.__shopSearchTextFousOut);
            this._shopSearchText.addEventListener(KeyboardEvent.KEY_DOWN, this.__shopSearchTextKeyDown);
            this._shopSearchBtn.addEventListener(MouseEvent.CLICK, this.__shopSearchBtnClick);
        }

        private function removeEvent():void
        {
            this._shopSearchText.removeEventListener(FocusEvent.FOCUS_IN, this.__shopSearchTextFousIn);
            this._shopSearchText.removeEventListener(FocusEvent.FOCUS_OUT, this.__shopSearchTextFousOut);
            this._shopSearchText.removeEventListener(KeyboardEvent.KEY_DOWN, this.__shopSearchTextKeyDown);
            this._shopSearchBtn.removeEventListener(MouseEvent.CLICK, this.__shopSearchBtnClick);
        }

        protected function __shopSearchTextKeyDown(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == 13)
            {
                this.__shopSearchBtnClick();
            };
        }

        protected function __shopSearchTextFousIn(_arg_1:FocusEvent):void
        {
            if (this._shopSearchText.text == LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText"))
            {
                this._shopSearchText.text = "";
            };
        }

        protected function __shopSearchTextFousOut(_arg_1:FocusEvent):void
        {
            if (this._shopSearchText.text.length == 0)
            {
                this._shopSearchText.text = LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText");
            };
        }

        protected function __shopSearchBtnClick(_arg_1:MouseEvent=null):void
        {
            var _local_2:Vector.<ShopItemInfo>;
            SoundManager.instance.play("008");
            if (((this._shopSearchText.text == LanguageMgr.GetTranslation("shop.view.ShopRankingView.shopSearchText")) || (this._shopSearchText.text.length == 0)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.ShopRankingView.PleaseEnterTheKeywords"));
                return;
            };
            if (this._currentShopSearchText != this._shopSearchText.text)
            {
                this._currentShopSearchText = this._shopSearchText.text;
                _local_2 = ShopManager.Instance.getDesignatedAllShopItem();
                _local_2 = ShopManager.Instance.fuzzySearch(_local_2, this._currentShopSearchText);
                this._currentList = _local_2;
            }
            else
            {
                _local_2 = this._currentList;
            };
            if (_local_2.length > 0)
            {
                this._controller.rightView.searchList(_local_2);
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.ShopRankingView.NoSearchResults"));
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._shopSearchBg);
            this._shopSearchBg = null;
            ObjectUtils.disposeObject(this._shopSearchBtn);
            this._shopSearchBtn = null;
            ObjectUtils.disposeObject(this._shopSearchText);
            this._shopSearchText = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package shop.view

