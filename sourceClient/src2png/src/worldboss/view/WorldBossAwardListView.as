// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.WorldBossAwardListView

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.events.ItemEvent;
    import com.pickgliss.utils.DisplayUtils;
    import flash.events.MouseEvent;
    import ddt.manager.ShopManager;
    import ddt.data.ShopType;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.controls.ISelectable;
    import shop.view.ShopGoodItem;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class WorldBossAwardListView extends Sprite implements Disposeable 
    {

        public static const AWARD_ITEM_NUM:uint = 6;

        private var _goodItemContainerAll:Sprite;
        private var _goodItems:Vector.<AwardGoodItem>;
        private var _firstPage:BaseButton;
        private var _prePageBtn:BaseButton;
        private var _nextPageBtn:BaseButton;
        private var _endPageBtn:BaseButton;
        private var _currentPage:int;
        private var _currentPageTxt:FilterFrameText;
        private var _pageBg:ScaleLeftRightImage;
        private var _list:Vector.<ShopItemInfo>;

        public function WorldBossAwardListView()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._pageBg = ComponentFactory.Instance.creatComponentByStylename("ddtlittleGameRightViewBG5");
            addChild(this._pageBg);
            this._firstPage = ComponentFactory.Instance.creat("worldbossAwardRoom.BtnFirstPage");
            this._prePageBtn = ComponentFactory.Instance.creat("worldbossAwardRoom.BtnPrePage");
            this._nextPageBtn = ComponentFactory.Instance.creat("worldbossAwardRoom.BtnNextPage");
            this._endPageBtn = ComponentFactory.Instance.creat("worldbossAwardRoom.BtnEndPage");
            this._currentPageTxt = ComponentFactory.Instance.creatComponentByStylename("worldbossAwardRoom.CurrentPage");
            this._goodItems = new Vector.<AwardGoodItem>();
            this._goodItemContainerAll = new Sprite();
            PositionUtils.setPos(this._goodItemContainerAll, "worldbossAwardRoom.goodItemContainer.pos");
            var _local_1:int;
            while (_local_1 < AWARD_ITEM_NUM)
            {
                this._goodItems[_local_1] = ComponentFactory.Instance.creatCustomObject("worldbossAwardRoom.GoodItem");
                this._goodItemContainerAll.addChild(this._goodItems[_local_1]);
                this._goodItems[_local_1].addEventListener(ItemEvent.ITEM_SELECT, this.__itemSelect);
                _local_1++;
            };
            DisplayUtils.horizontalArrange(this._goodItemContainerAll, 2, 0, 2);
            addChild(this._firstPage);
            addChild(this._prePageBtn);
            addChild(this._nextPageBtn);
            addChild(this._endPageBtn);
            addChild(this._currentPageTxt);
            addChild(this._goodItemContainerAll);
            this._currentPage = 1;
            this.loadList();
        }

        private function addEvent():void
        {
            this._firstPage.addEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            this._prePageBtn.addEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            this._nextPageBtn.addEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            this._endPageBtn.addEventListener(MouseEvent.CLICK, this.__pageBtnClick);
        }

        public function updata():void
        {
            var _local_1:int;
            while (_local_1 < this._goodItems.length)
            {
                this._goodItems[_local_1].updata();
                _local_1++;
            };
        }

        private function removeEvent():void
        {
            this._firstPage.removeEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            this._prePageBtn.removeEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            this._nextPageBtn.removeEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            this._endPageBtn.removeEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            var _local_1:uint;
            while (_local_1 < AWARD_ITEM_NUM)
            {
                this._goodItems[_local_1].removeEventListener(ItemEvent.ITEM_CLICK, this.__itemSelect);
                _local_1++;
            };
        }

        public function loadList():void
        {
            this.setList(ShopManager.Instance.getValidSortedGoodsByType(ShopType.WORLDBOSS_AWARD_TYPE, this._currentPage, AWARD_ITEM_NUM));
        }

        public function setList(_arg_1:Vector.<ShopItemInfo>):void
        {
            this._list = _arg_1;
            this.clearitems();
            var _local_2:int;
            while (_local_2 < AWARD_ITEM_NUM)
            {
                this._goodItems[_local_2].selected = false;
                if (((_local_2 < _arg_1.length) && (_arg_1[_local_2])))
                {
                    this._goodItems[_local_2].shopItemInfo = _arg_1[_local_2];
                };
                _local_2++;
            };
            this._currentPageTxt.text = ((this._currentPage + "/") + ShopManager.Instance.getResultPages(ShopType.WORLDBOSS_AWARD_TYPE, AWARD_ITEM_NUM));
        }

        private function clearitems():void
        {
            var _local_1:int;
            while (_local_1 < AWARD_ITEM_NUM)
            {
                this._goodItems[_local_1].shopItemInfo = null;
                _local_1++;
            };
        }

        private function __pageBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (ShopManager.Instance.getResultPages(ShopType.WORLDBOSS_AWARD_TYPE) == 0)
            {
                return;
            };
            switch (_arg_1.currentTarget)
            {
                case this._firstPage:
                    if (this._currentPage != 1)
                    {
                        this._currentPage = 1;
                    };
                    break;
                case this._prePageBtn:
                    if (this._currentPage == 1)
                    {
                        this._currentPage = (ShopManager.Instance.getResultPages(ShopType.WORLDBOSS_AWARD_TYPE, AWARD_ITEM_NUM) + 1);
                    };
                    this._currentPage--;
                    break;
                case this._nextPageBtn:
                    if (this._currentPage == ShopManager.Instance.getResultPages(ShopType.WORLDBOSS_AWARD_TYPE, AWARD_ITEM_NUM))
                    {
                        this._currentPage = 0;
                    };
                    this._currentPage++;
                    break;
                case this._endPageBtn:
                    if (this._currentPage != ShopManager.Instance.getResultPages(ShopType.WORLDBOSS_AWARD_TYPE, AWARD_ITEM_NUM))
                    {
                        this._currentPage = ShopManager.Instance.getResultPages(ShopType.WORLDBOSS_AWARD_TYPE, AWARD_ITEM_NUM);
                    };
                    break;
            };
            this.loadList();
        }

        private function __itemSelect(_arg_1:ItemEvent):void
        {
            var _local_3:ISelectable;
            _arg_1.stopImmediatePropagation();
            var _local_2:ShopGoodItem = (_arg_1.currentTarget as ShopGoodItem);
            for each (_local_3 in this._goodItems)
            {
                _local_3.selected = false;
            };
            _local_2.selected = true;
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this._goodItemContainerAll);
            ObjectUtils.disposeAllChildren(this);
            this._goodItemContainerAll = null;
            this._goodItems = null;
            this._firstPage = null;
            this._prePageBtn = null;
            this._endPageBtn = null;
            this._nextPageBtn = null;
            this._currentPageTxt = null;
            this._pageBg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package worldboss.view

