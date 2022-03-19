// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopRightView

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Image;
    import flash.display.Bitmap;
    import shop.ShopController;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.controls.SelectedButton;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import com.pickgliss.ui.controls.container.HBox;
    import flash.display.MovieClip;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import ddt.manager.LanguageMgr;
    import ddt.events.ItemEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.ShopManager;
    import shop.ShopEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.data.ShopType;
    import com.pickgliss.ui.controls.ISelectable;
    import ddt.data.goods.ShopCarItemInfo;
    import ddt.manager.MessageTipManager;
    import ddt.data.EquipType;
    import com.pickgliss.utils.ObjectUtils;
    import com.greensock.TweenProxy;
    import com.greensock.TimelineLite;
    import com.greensock.TweenLite;
    import flash.display.BitmapData;
    import com.pickgliss.utils.DisplayUtils;
    import flash.geom.Point;
    import flash.display.DisplayObject;
    import __AS3__.vec.*;

    public class ShopRightView extends Sprite implements Disposeable 
    {

        public static const VIP_SHOPID:int = 60;
        public static const M_SPECIALPROPS:int = 30;
        public static const F_SPECIALPROPS:int = 31;
        public static const TOP_RECOMMEND:uint = 0;
        public static const SHOP_ITEM_NUM:uint = 12;
        public static var CURRENT_GENDER:int = -1;
        public static var CURRENT_MONEY_TYPE:int = 1;
        public static var CURRENT_PAGE:int = 1;
        public static var TOP_TYPE:int = 0;
        public static var SUB_TYPE:int = 0;
        public static const SHOW_LIGHT:String = "SHOW_LIGHT";
        private static var isDiscountType:Boolean = false;

        private var _bg:Image;
        private var _bg1:Bitmap;
        private var _controller:ShopController;
        private var _currentPageTxt:FilterFrameText;
        private var _currentPageInput:ScaleLeftRightImage;
        private var _femaleBtn:SelectedButton;
        private var _genderContainer:VBox;
        private var _genderGroup:SelectedButtonGroup;
        private var _rightViewTitleBg:Bitmap;
        private var _goodItemContainerAll:Sprite;
        private var _goodItemContainerBg:Bitmap;
        private var _goodItemGroup:SelectedButtonGroup;
        private var _goodItems:Vector.<ShopGoodItem>;
        private var _maleBtn:SelectedButton;
        private var _firstPage:BaseButton;
        private var _prePageBtn:BaseButton;
        private var _nextPageBtn:BaseButton;
        private var _endPageBtn:BaseButton;
        private var _subBtns:Vector.<SelectedTextButton>;
        private var _subBtnsContainers:Vector.<HBox>;
        private var _subBtnsGroups:Vector.<SelectedButtonGroup>;
        private var _currentSubBtnContainerIndex:int;
        private var _topBtns:Vector.<SelectedTextButton>;
        private var _topBtnsContainer:HBox;
        private var _topBtnsGroup:SelectedButtonGroup;
        private var _shopSearchBox:Sprite;
        private var _shopSearchEndBtnBg:Bitmap;
        private var _shopSearchColseBtn:BaseButton;
        private var _rightItemLightMc:MovieClip;
        private var _tempTopType:int = -1;
        private var _tempCurrentPage:int = -1;
        private var _tempSubBtnHBox:HBox;
        private var _isSearch:Boolean;
        private var _searchShopItemList:Vector.<ShopItemInfo>;
        private var _searchItemTotalPage:int;


        public function get genderGroup():SelectedButtonGroup
        {
            return (this._genderGroup);
        }

        public function setup(_arg_1:ShopController):void
        {
            this._controller = _arg_1;
            this.init();
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creat("ddtshop.RightViewBg");
            addChild(this._bg);
            this._rightViewTitleBg = ComponentFactory.Instance.creatBitmap("asset.ddtshop.RightViewTitleBg");
            addChild(this._rightViewTitleBg);
            this.initBtns();
            this.initEvent();
            if (CURRENT_GENDER < 0)
            {
                this.setCurrentSex(((PlayerManager.Instance.Self.Sex) ? 1 : 2));
            };
        }

        private function initBtns():void
        {
            var topBtnTextTranslation:Array;
            var subBtnTextTranslation:Array;
            var dx:Number;
            var dy:Number;
            var k:uint;
            var i:uint;
            this._topBtns = new Vector.<SelectedTextButton>();
            this._topBtnsGroup = new SelectedButtonGroup();
            this._subBtns = new Vector.<SelectedTextButton>();
            this._subBtnsContainers = new Vector.<HBox>();
            this._subBtnsGroups = new Vector.<SelectedButtonGroup>();
            this._genderGroup = new SelectedButtonGroup();
            this._goodItems = new Vector.<ShopGoodItem>();
            this._goodItemGroup = new SelectedButtonGroup();
            this._firstPage = ComponentFactory.Instance.creat("ddtshop.BtnFirstPage");
            this._prePageBtn = ComponentFactory.Instance.creat("ddtshop.BtnPrePage");
            this._nextPageBtn = ComponentFactory.Instance.creat("ddtshop.BtnNextPage");
            this._endPageBtn = ComponentFactory.Instance.creat("ddtshop.BtnEndPage");
            this._currentPageTxt = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CurrentPage");
            this._currentPageInput = ComponentFactory.Instance.creatComponentByStylename("ddtshop.CurrentPageInput");
            this._topBtnsContainer = ComponentFactory.Instance.creat("ddtshop.TopBtnContainer");
            var topBtnStyleName:Array = ["ddtshop.TopBtnFashionArea", "ddtshop.TopBtnPropArea"];
            topBtnTextTranslation = ["shop.ShopRightView.TopBtn.FashionArea", "shop.ShopRightView.TopBtn.propArea"];
            topBtnStyleName.forEach(function (_arg_1:*, _arg_2:int, _arg_3:Array):void
            {
                var _local_4:SelectedTextButton = ComponentFactory.Instance.creat((_arg_1 as String));
                _local_4.text = LanguageMgr.GetTranslation(topBtnTextTranslation[_arg_2]);
                _topBtns.push(_local_4);
            });
            this._goodItemContainerBg = ComponentFactory.Instance.creatBitmap("ddtshop.GoodItemContainerBg");
            addChild(this._goodItemContainerBg);
            this._genderContainer = ComponentFactory.Instance.creat("ddtshop.GenderBtnContainer");
            this._maleBtn = ComponentFactory.Instance.creat("ddtshop.GenderBtnMale");
            this._femaleBtn = ComponentFactory.Instance.creat("ddtshop.GenderBtnFemale");
            this._rightItemLightMc = ComponentFactory.Instance.creatCustomObject("ddtshop.RightItemLightMc");
            this._goodItemContainerAll = ComponentFactory.Instance.creatCustomObject("ddtshop.GoodItemContainerAll");
            i = 0;
            while (i < SHOP_ITEM_NUM)
            {
                this._goodItems[i] = ComponentFactory.Instance.creatCustomObject("ddtshop.GoodItem");
                dx = (this._goodItems[i].width + 10);
                dy = (this._goodItems[i].height + 10);
                dx = (dx * int((i % 3)));
                dy = (dy * int((i / 3)));
                this._goodItems[i].x = dx;
                this._goodItems[i].y = (dy + ((i / 3) * 3));
                this._goodItemContainerAll.addChild(this._goodItems[i]);
                this._goodItems[i].setItemLight(this._rightItemLightMc);
                this._goodItems[i].addEventListener(ItemEvent.ITEM_CLICK, this.__itemClick);
                this._goodItems[i].addEventListener(ItemEvent.ITEM_SELECT, this.__itemSelect);
                i++;
            };
            this._maleBtn.displacement = (this._femaleBtn.displacement = false);
            this._genderContainer.addChild(this._femaleBtn);
            this._genderContainer.addChild(this._maleBtn);
            this._genderGroup.addSelectItem(this._maleBtn);
            this._genderGroup.addSelectItem(this._femaleBtn);
            i = 0;
            while (i < this._topBtns.length)
            {
                this._topBtns[i].addEventListener(MouseEvent.CLICK, this.__topBtnClick);
                this._topBtnsContainer.addChild(this._topBtns[i]);
                this._topBtnsGroup.addSelectItem(this._topBtns[i]);
                if (i == 0)
                {
                    this._topBtnsGroup.selectIndex = i;
                };
                this._subBtnsGroups[i] = new SelectedButtonGroup();
                i++;
            };
            this._subBtnsContainers.push(ComponentFactory.Instance.creat("ddtshop.SubBtnContainerRecommend"));
            this._subBtnsContainers.push(ComponentFactory.Instance.creat("ddtshop.SubBtnContainerEquipment"));
            this._subBtnsContainers.push(ComponentFactory.Instance.creat("ddtshop.SubBtnContainerBeautyup"));
            var subBtnStyleName:Array = ["ddtshop.SubBtnCloth", "ddtshop.SubBtnHat", "ddtshop.SubBtnEye", "ddtshop.SubBtnFace", "ddtshop.SubBtnHair", "ddtshop.SubBtnSuit", "ddtshop.SubBtnGlasses", "ddtshop.SubBtnBubble", "ddtshop.SubBtnprop"];
            subBtnTextTranslation = ["shop.ShopRightView.SubBtn.cloth", "shop.ShopRightView.SubBtn.hat", "shop.ShopRightView.SubBtn.eye", "shop.ShopRightView.SubBtn.face", "shop.ShopRightView.SubBtn.hair", "shop.ShopRightView.SubBtn.suit", "shop.ShopRightView.SubBtn.glasses", "shop.ShopRightView.SubBtn.Bubble", "shop.ShopRightView.SubBtn.prop"];
            subBtnStyleName.forEach(function (_arg_1:*, _arg_2:int, _arg_3:Array):void
            {
                var _local_4:SelectedTextButton = ComponentFactory.Instance.creat((_arg_1 as String));
                _local_4.text = LanguageMgr.GetTranslation(subBtnTextTranslation[_arg_2]);
                _subBtns.push(_local_4);
            });
            var controlArr:Array = [8, 9];
            k = 0;
            i = 0;
            while (i < 9)
            {
                if (i == controlArr[k])
                {
                    k++;
                };
                if (this._subBtnsContainers[k] == null)
                {
                    k++;
                };
                this._subBtns[i].addEventListener(MouseEvent.CLICK, this.__subBtnClick);
                this._subBtnsContainers[k].addChild(this._subBtns[i]);
                this._subBtnsGroups[k].addSelectItem(this._subBtns[i]);
                if (i == 0)
                {
                    this._subBtnsGroups[k].selectIndex = i;
                };
                this._subBtnsGroups[k].addEventListener(Event.CHANGE, this.subButtonSelectedChangeHandler);
                i++;
            };
            addChild(this._firstPage);
            addChild(this._prePageBtn);
            addChild(this._nextPageBtn);
            addChild(this._endPageBtn);
            addChild(this._currentPageInput);
            addChild(this._currentPageTxt);
            addChild(this._genderContainer);
            addChild(this._goodItemContainerAll);
            addChild(this._topBtnsContainer);
            i = 0;
            while (i < this._subBtnsContainers.length)
            {
                if (this._subBtnsContainers[i])
                {
                    addChild(this._subBtnsContainers[i]);
                    this._subBtnsContainers[i].visible = false;
                    if (i == 0)
                    {
                        this._subBtnsContainers[i].visible = true;
                    };
                };
                i++;
            };
            this._shopSearchBox = ComponentFactory.Instance.creatCustomObject("ddtshop.SearchBox");
            this._shopSearchEndBtnBg = ComponentFactory.Instance.creatBitmap("asset.ddtshop.SearchResultImage");
            this._shopSearchBox.addChild(this._shopSearchEndBtnBg);
            this._shopSearchColseBtn = ComponentFactory.Instance.creatComponentByStylename("ddtshop.ShopSearchColseBtn");
            this._shopSearchBox.addChild(this._shopSearchColseBtn);
            addChild(this._shopSearchBox);
            this._shopSearchBox.visible = false;
            this._currentSubBtnContainerIndex = SUB_TYPE;
            this._topBtnsContainer.arrange();
        }

        private function subButtonSelectedChangeHandler(_arg_1:Event):void
        {
            if (this._currentSubBtnContainerIndex >= 3)
            {
                this._currentSubBtnContainerIndex = 1;
            };
            this._subBtnsContainers[this._currentSubBtnContainerIndex].arrange();
        }

        private function initEvent():void
        {
            this._topBtnsGroup.addEventListener(Event.CHANGE, this.__topBtnChangeHandler);
            this._maleBtn.addEventListener(MouseEvent.CLICK, this.__genderClick);
            this._femaleBtn.addEventListener(MouseEvent.CLICK, this.__genderClick);
            this._firstPage.addEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            this._prePageBtn.addEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            this._nextPageBtn.addEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            this._endPageBtn.addEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            this._shopSearchColseBtn.addEventListener(MouseEvent.CLICK, this.__shopSearchColseBtnClick);
            ShopManager.Instance.addEventListener(ShopEvent.SHOW_WEAK_GUILDE, this.showUserGuide);
            this.showUserGuide();
        }

        protected function __topBtnChangeHandler(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            this._topBtnsContainer.arrange();
        }

        private function showUserGuide(_arg_1:ShopEvent=null):void
        {
            if (((SavePointManager.Instance.isInSavePoint(15)) && (!(TaskManager.instance.isNewHandTaskCompleted(11)))))
            {
                if (this._controller.model.allItemsCount > 0)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SHOP_GIFT, 45, "trainer.buyConfirmArrowPos", "", "", null);
                }
                else
                {
                    NewHandContainer.Instance.showArrow(ArrowType.SHOP_GIFT, 180, "trainer.buyThingsArrowPos", "", "", null);
                };
            };
        }

        private function reoveArrow():void
        {
            NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
        }

        protected function __shopSearchColseBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._isSearch = false;
            this._shopSearchBox.visible = false;
            TOP_TYPE = this._tempTopType;
            this._tempTopType = -1;
            this._topBtnsGroup.selectIndex = TOP_TYPE;
            if ((!(this._tempSubBtnHBox)))
            {
                this._tempSubBtnHBox = this._subBtnsContainers[0];
            };
            this._tempSubBtnHBox.visible = true;
            CURRENT_PAGE = this._tempCurrentPage;
            this._tempCurrentPage = -1;
            this.loadList();
        }

        public function loadList():void
        {
            if (this._isSearch)
            {
                return;
            };
            this.setList(ShopManager.Instance.getValidSortedGoodsByType(this.getType(), CURRENT_PAGE));
        }

        private function getType():int
        {
            var _local_1:Array = [];
            _local_1 = ((CURRENT_GENDER == 1) ? ShopType.MALE_MONEY_TYPE : ShopType.FEMALE_MONEY_TYPE);
            var _local_2:* = _local_1[TOP_TYPE];
            if (((_local_2 is Array) && (SUB_TYPE > -1)))
            {
                _local_2 = _local_2[SUB_TYPE];
            };
            return (int(_local_2));
        }

        public function setCurrentSex(_arg_1:int):void
        {
            CURRENT_GENDER = _arg_1;
            this._genderGroup.selectIndex = (CURRENT_GENDER - 1);
        }

        public function setList(_arg_1:Vector.<ShopItemInfo>):void
        {
            this.clearitems();
            var _local_2:int;
            while (_local_2 < SHOP_ITEM_NUM)
            {
                this._goodItems[_local_2].selected = false;
                if ((!(_arg_1))) break;
                this._goodItems[_local_2].ableButton();
                if (((_local_2 < _arg_1.length) && (_arg_1[_local_2])))
                {
                    this._goodItems[_local_2].shopItemInfo = _arg_1[_local_2];
                };
                if ((!(SavePointManager.Instance.savePoints[15])))
                {
                    this._goodItems[_local_2].givingDisable();
                };
                if (((this.getType() == M_SPECIALPROPS) && ((PlayerManager.Instance.Self.VIPLevel < 5) || (PlayerManager.Instance.Self.VIPtype == 0))))
                {
                    this._goodItems[_local_2].enableButton();
                };
                if (((this.getType() == F_SPECIALPROPS) && ((PlayerManager.Instance.Self.VIPLevel < 5) || (PlayerManager.Instance.Self.VIPtype == 0))))
                {
                    this._goodItems[_local_2].enableButton();
                };
                _local_2++;
            };
            this._currentPageTxt.text = ((CURRENT_PAGE + "/") + ShopManager.Instance.getResultPages(this.getType()));
        }

        public function searchList(_arg_1:Vector.<ShopItemInfo>):void
        {
            var _local_3:HBox;
            if (((this._searchShopItemList == _arg_1) && (this._isSearch)))
            {
                return;
            };
            this._searchShopItemList = _arg_1;
            if ((!(this._isSearch)))
            {
                this._tempTopType = TOP_TYPE;
                this._tempCurrentPage = CURRENT_PAGE;
            };
            this._isSearch = true;
            TOP_TYPE = -1;
            this._topBtnsGroup.selectIndex = -1;
            this._topBtnsContainer.arrange();
            CURRENT_PAGE = 1;
            var _local_2:int;
            while (_local_2 < this._subBtnsContainers.length)
            {
                _local_3 = (this._subBtnsContainers[_local_2] as HBox);
                if (_local_3)
                {
                    _local_3.visible = false;
                };
                _local_2++;
            };
            this._shopSearchBox.visible = true;
            this.runSearch();
        }

        private function runSearch():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            this.clearitems();
            this._searchItemTotalPage = Math.ceil((this._searchShopItemList.length / 12));
            if (((CURRENT_PAGE > 0) && (CURRENT_PAGE <= this._searchItemTotalPage)))
            {
                _local_1 = (12 * (CURRENT_PAGE - 1));
                _local_2 = Math.min((this._searchShopItemList.length - _local_1), 12);
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    this._goodItems[_local_3].ableButton();
                    this._goodItems[_local_3].selected = false;
                    if ((!(SavePointManager.Instance.savePoints[15])))
                    {
                        this._goodItems[_local_3].givingDisable();
                    };
                    if (this._searchShopItemList[(_local_3 + _local_1)])
                    {
                        this._goodItems[_local_3].shopItemInfo = this._searchShopItemList[(_local_3 + _local_1)];
                        _local_4 = this._searchShopItemList[(_local_3 + _local_1)].ShopID;
                        if (((_local_4 == VIP_SHOPID) && (PlayerManager.Instance.Self.VIPLevel < 5)))
                        {
                            this._goodItems[_local_3].enableButton();
                            if ((!(PlayerManager.Instance.Self.IsVIP)))
                            {
                                this._goodItems[_local_3].enableButton();
                            };
                        };
                    };
                    _local_3++;
                };
            };
            this._currentPageTxt.text = ((CURRENT_PAGE + "/") + this._searchItemTotalPage);
        }

        private function __genderClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:int = (((_arg_1.currentTarget as SelectedButton) == this._maleBtn) ? 1 : 2);
            if (CURRENT_GENDER == _local_2)
            {
                return;
            };
            this.setCurrentSex(_local_2);
            if ((!(this._isSearch)))
            {
                CURRENT_PAGE = 1;
            };
            this._controller.setFittingModel((CURRENT_GENDER == 1));
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

        private function __itemClick(_arg_1:ItemEvent):void
        {
            var _local_3:ISelectable;
            var _local_4:ISelectable;
            var _local_5:Boolean;
            var _local_6:int;
            var _local_7:Boolean;
            var _local_8:ShopCarItemInfo;
            var _local_2:ShopGoodItem = (_arg_1.currentTarget as ShopGoodItem);
            if (this._controller.model.isOverCount(_local_2.shopItemInfo))
            {
                for each (_local_3 in this._goodItems)
                {
                    _local_3.selected = (_local_3 == _local_2);
                };
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIModel.GoodsNumberLimit"));
                return;
            };
            if (((_local_2.shopItemInfo) && (_local_2.shopItemInfo.TemplateInfo)))
            {
                for each (_local_4 in this._goodItems)
                {
                    _local_4.selected = (_local_4 == _local_2);
                };
                _local_6 = _local_2.shopItemInfo.ShopID;
                if (EquipType.dressAble(_local_2.shopItemInfo.TemplateInfo))
                {
                    if (_local_6 == VIP_SHOPID)
                    {
                        if (PlayerManager.Instance.Self.VIPLevel < 5)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.VIPshop"));
                            return;
                        };
                        if ((!(PlayerManager.Instance.Self.IsVIP)))
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.VIPshop1"));
                            return;
                        };
                    };
                    if ((((!(this.getType() == F_SPECIALPROPS)) && (!(this.getType() == M_SPECIALPROPS))) || (PlayerManager.Instance.Self.IsVIP)))
                    {
                        this._controller.addTempEquip(_local_2.shopItemInfo);
                    };
                }
                else
                {
                    _local_8 = new ShopCarItemInfo(_local_2.shopItemInfo.GoodsID, _local_2.shopItemInfo.TemplateID);
                    ObjectUtils.copyProperties(_local_8, _local_2.shopItemInfo);
                    _local_6 = _local_8.ShopID;
                    if (_local_6 == VIP_SHOPID)
                    {
                        if (PlayerManager.Instance.Self.VIPLevel < 5)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.VIPshop"));
                            return;
                        };
                        if ((!(PlayerManager.Instance.Self.IsVIP)))
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.changeColor.VIPshop1"));
                            return;
                        };
                    };
                    _local_5 = this._controller.addToCar(_local_8);
                };
                this.showUserGuide();
                this.itemClick(_local_2);
                _local_7 = this._controller.leftView.getColorEditorVisble();
                if (((_local_5) && (!(_local_7))))
                {
                    this.addCartEffects(_local_2.itemCell);
                };
            };
            dispatchEvent(new Event(SHOW_LIGHT));
        }

        private function addCartEffects(_arg_1:DisplayObject):void
        {
            var _local_4:TweenProxy;
            var _local_5:TimelineLite;
            var _local_6:TweenLite;
            var _local_7:TweenLite;
            if ((!(_arg_1)))
            {
                return;
            };
            var _local_2:BitmapData = new BitmapData(_arg_1.width, _arg_1.height, true, 0);
            _local_2.draw(_arg_1);
            var _local_3:Bitmap = new Bitmap(_local_2, "auto", true);
            parent.addChild(_local_3);
            _local_4 = TweenProxy.create(_local_3);
            _local_4.registrationX = (_local_4.width / 2);
            _local_4.registrationY = (_local_4.height / 2);
            var _local_8:Point = DisplayUtils.localizePoint(parent, _arg_1);
            _local_4.x = (_local_8.x + (_local_4.width / 2));
            _local_4.y = (_local_8.y + (_local_4.height / 2));
            _local_5 = new TimelineLite();
            _local_5.vars.onComplete = this.twComplete;
            _local_5.vars.onCompleteParams = [_local_5, _local_4, _local_3];
            _local_6 = new TweenLite(_local_4, 0.3, {
                "x":220,
                "y":430
            });
            _local_7 = new TweenLite(_local_4, 0.3, {
                "scaleX":0.1,
                "scaleY":0.1
            });
            _local_5.append(_local_6);
            _local_5.append(_local_7, -0.2);
        }

        private function twComplete(_arg_1:TimelineLite, _arg_2:TweenProxy, _arg_3:Bitmap):void
        {
            if (_arg_1)
            {
                _arg_1.kill();
            };
            if (_arg_2)
            {
                _arg_2.destroy();
            };
            if (_arg_3.parent)
            {
                _arg_3.parent.removeChild(_arg_3);
                _arg_3.bitmapData.dispose();
            };
            _arg_2 = null;
            _arg_3 = null;
            _arg_1 = null;
        }

        private function itemClick(_arg_1:ShopGoodItem):void
        {
            if (_arg_1.shopItemInfo.TemplateInfo != null)
            {
                if (((!(CURRENT_GENDER == _arg_1.shopItemInfo.TemplateInfo.NeedSex)) && (!(_arg_1.shopItemInfo.TemplateInfo.NeedSex == 0))))
                {
                    this.setCurrentSex(_arg_1.shopItemInfo.TemplateInfo.NeedSex);
                    this._controller.setFittingModel((CURRENT_GENDER == 1));
                };
            };
        }

        private function __pageBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if ((!(this._isSearch)))
            {
                if (ShopManager.Instance.getResultPages(this.getType()) == 0)
                {
                    return;
                };
                switch (_arg_1.currentTarget)
                {
                    case this._firstPage:
                        if (CURRENT_PAGE != 1)
                        {
                            CURRENT_PAGE = 1;
                        };
                        break;
                    case this._prePageBtn:
                        if (CURRENT_PAGE == 1)
                        {
                            CURRENT_PAGE = (ShopManager.Instance.getResultPages(this.getType()) + 1);
                        };
                        CURRENT_PAGE--;
                        break;
                    case this._nextPageBtn:
                        if (CURRENT_PAGE == ShopManager.Instance.getResultPages(this.getType()))
                        {
                            CURRENT_PAGE = 0;
                        };
                        CURRENT_PAGE++;
                        break;
                    case this._endPageBtn:
                        if (CURRENT_PAGE != ShopManager.Instance.getResultPages(this.getType()))
                        {
                            CURRENT_PAGE = ShopManager.Instance.getResultPages(this.getType());
                        };
                        break;
                };
                this.loadList();
            }
            else
            {
                switch (_arg_1.currentTarget)
                {
                    case this._firstPage:
                        if (CURRENT_PAGE != 1)
                        {
                            CURRENT_PAGE = 1;
                        };
                        break;
                    case this._prePageBtn:
                        if (CURRENT_PAGE == 1)
                        {
                            CURRENT_PAGE = (this._searchItemTotalPage + 1);
                        };
                        CURRENT_PAGE--;
                        break;
                    case this._nextPageBtn:
                        if (CURRENT_PAGE == this._searchItemTotalPage)
                        {
                            CURRENT_PAGE = 0;
                        };
                        CURRENT_PAGE++;
                        break;
                    case this._endPageBtn:
                        if (CURRENT_PAGE != this._searchItemTotalPage)
                        {
                            CURRENT_PAGE = this._searchItemTotalPage;
                        };
                        break;
                };
                this.runSearch();
            };
        }

        private function __subBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.reoveArrow();
            var _local_2:int = this._subBtnsContainers[TOP_TYPE].getChildIndex((_arg_1.currentTarget as SelectedButton));
            if (_local_2 != SUB_TYPE)
            {
                SUB_TYPE = _local_2;
                CURRENT_PAGE = 1;
                this.loadList();
            };
        }

        private function __topBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._topBtnsContainer.arrange();
            var _local_2:int = this._topBtns.indexOf((_arg_1.currentTarget as SelectedButton));
            this._isSearch = false;
            this._shopSearchBox.visible = false;
            this._tempTopType = -1;
            this._tempCurrentPage = -1;
            if (_local_2 != TOP_TYPE)
            {
                TOP_TYPE = _local_2;
                SUB_TYPE = 0;
                CURRENT_PAGE = 1;
                this.showSubBtns(_local_2);
                this._currentSubBtnContainerIndex = _local_2;
                this.loadList();
            };
            if (_local_2 == 0)
            {
                this.showUserGuide();
            }
            else
            {
                if (this._controller.model.allItemsCount <= 0)
                {
                    NewHandContainer.Instance.clearArrowByID(ArrowType.SHOP_GIFT);
                };
            };
        }

        private function disposeUserGuide():void
        {
        }

        private function clearitems():void
        {
            var _local_1:int;
            while (_local_1 < SHOP_ITEM_NUM)
            {
                this._goodItems[_local_1].shopItemInfo = null;
                _local_1++;
            };
        }

        private function removeEvent():void
        {
            this._topBtnsGroup.removeEventListener(Event.CHANGE, this.__topBtnChangeHandler);
            this._maleBtn.removeEventListener(MouseEvent.CLICK, this.__genderClick);
            this._femaleBtn.removeEventListener(MouseEvent.CLICK, this.__genderClick);
            this._prePageBtn.removeEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            this._nextPageBtn.removeEventListener(MouseEvent.CLICK, this.__pageBtnClick);
            var _local_1:uint;
            while (_local_1 < SHOP_ITEM_NUM)
            {
                this._goodItems[_local_1].removeEventListener(ItemEvent.ITEM_CLICK, this.__itemClick);
                this._goodItems[_local_1].removeEventListener(ItemEvent.ITEM_SELECT, this.__itemSelect);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this._topBtns.length)
            {
                this._topBtns[_local_1].removeEventListener(MouseEvent.CLICK, this.__topBtnClick);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this._subBtns.length)
            {
                this._subBtns[_local_1].removeEventListener(MouseEvent.CLICK, this.__subBtnClick);
                _local_1++;
            };
            this._shopSearchColseBtn.removeEventListener(MouseEvent.CLICK, this.__shopSearchColseBtnClick);
            ShopManager.Instance.removeEventListener(ShopEvent.SHOW_WEAK_GUILDE, this.showUserGuide);
        }

        private function showSubBtns(_arg_1:int):void
        {
            var _local_3:HBox;
            var _local_2:int;
            while (_local_2 < this._subBtnsContainers.length)
            {
                _local_3 = (this._subBtnsContainers[_local_2] as HBox);
                if (_local_3)
                {
                    _local_3.visible = false;
                };
                _local_2++;
            };
            if (this._subBtnsContainers[_arg_1])
            {
                this._subBtnsContainers[_arg_1].visible = true;
                this._tempSubBtnHBox = this._subBtnsContainers[_arg_1];
                this._subBtnsGroups[_arg_1].selectIndex = SUB_TYPE;
                this._subBtnsContainers[_arg_1].arrange();
            };
        }

        public function gotoPage(_arg_1:int=-1, _arg_2:int=-1, _arg_3:int=1, _arg_4:int=1):void
        {
            var _local_6:HBox;
            if (_arg_1 != -1)
            {
                TOP_TYPE = _arg_1;
            };
            if (_arg_2 != -1)
            {
                SUB_TYPE = _arg_2;
            };
            CURRENT_PAGE = _arg_3;
            CURRENT_GENDER = _arg_4;
            this._topBtnsGroup.selectIndex = TOP_TYPE;
            this._subBtnsGroups[TOP_TYPE].selectIndex = SUB_TYPE;
            this._genderGroup.selectIndex = (CURRENT_GENDER - 1);
            this.setCurrentSex(CURRENT_GENDER);
            this._currentPageTxt.text = ((CURRENT_PAGE + "/") + this._searchItemTotalPage);
            var _local_5:int;
            while (_local_5 < this._subBtnsContainers.length)
            {
                _local_6 = (this._subBtnsContainers[_local_5] as HBox);
                if (_local_6)
                {
                    _local_6.visible = false;
                };
                _local_5++;
            };
            if (this._subBtnsContainers[TOP_TYPE])
            {
                this._subBtnsContainers[TOP_TYPE].visible = true;
                this._subBtnsContainers[TOP_TYPE].arrange();
                this._tempSubBtnHBox = this._subBtnsContainers[TOP_TYPE];
            };
            this.loadList();
        }

        public function dispose():void
        {
            if (this._tempCurrentPage > -1)
            {
                CURRENT_PAGE = this._tempCurrentPage;
            };
            if (this._tempTopType > -1)
            {
                TOP_TYPE = this._tempTopType;
            };
            this.removeEvent();
            this.disposeUserGuide();
            ObjectUtils.disposeAllChildren(this);
            if (this._currentPageTxt)
            {
                this._currentPageTxt.dispose();
            };
            this._currentPageTxt = null;
            var _local_1:int;
            while (_local_1 < this._goodItems.length)
            {
                ObjectUtils.disposeObject(this._goodItems[_local_1]);
                this._goodItems[_local_1] = null;
                _local_1++;
            };
            ObjectUtils.disposeObject(this._goodItems);
            this._goodItems = null;
            _local_1 = 0;
            while (_local_1 < this._topBtns.length)
            {
                ObjectUtils.disposeObject(this._topBtns[_local_1]);
                this._topBtns[_local_1] = null;
                _local_1++;
            };
            ObjectUtils.disposeObject(this._topBtns);
            this._topBtns = null;
            _local_1 = 0;
            while (_local_1 < this._subBtns.length)
            {
                ObjectUtils.disposeObject(this._subBtns[_local_1]);
                this._subBtns[_local_1] = null;
                _local_1++;
            };
            this._subBtns = null;
            _local_1 = 0;
            while (_local_1 < this._subBtnsGroups.length)
            {
                ObjectUtils.disposeObject(this._subBtnsGroups[_local_1]);
                this._subBtnsGroups[_local_1] = null;
                ObjectUtils.disposeObject(this._subBtnsContainers[_local_1]);
                this._subBtnsContainers[_local_1] = null;
                _local_1++;
            };
            ObjectUtils.disposeObject(this._subBtnsContainers);
            this._subBtnsContainers = null;
            ObjectUtils.disposeObject(this._subBtnsGroups);
            this._subBtnsGroups = null;
            ObjectUtils.disposeObject(this._controller);
            this._controller = null;
            ObjectUtils.disposeObject(this._goodItemGroup);
            this._goodItemGroup = null;
            ObjectUtils.disposeObject(this._nextPageBtn);
            this._nextPageBtn = null;
            ObjectUtils.disposeObject(this._prePageBtn);
            this._prePageBtn = null;
            ObjectUtils.disposeObject(this._topBtnsGroup);
            this._topBtnsGroup = null;
            ObjectUtils.disposeObject(this._tempSubBtnHBox);
            this._tempSubBtnHBox = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._bg1);
            this._bg1 = null;
            ObjectUtils.disposeObject(this._currentPageInput);
            this._currentPageInput = null;
            ObjectUtils.disposeObject(this._femaleBtn);
            this._femaleBtn = null;
            ObjectUtils.disposeObject(this._genderContainer);
            this._genderContainer = null;
            ObjectUtils.disposeObject(this._genderGroup);
            this._genderGroup = null;
            ObjectUtils.disposeObject(this._rightViewTitleBg);
            this._rightViewTitleBg = null;
            ObjectUtils.disposeObject(this._goodItemContainerAll);
            this._goodItemContainerAll = null;
            ObjectUtils.disposeObject(this._maleBtn);
            this._maleBtn = null;
            ObjectUtils.disposeObject(this._firstPage);
            this._firstPage = null;
            ObjectUtils.disposeObject(this._prePageBtn);
            this._prePageBtn = null;
            ObjectUtils.disposeObject(this._nextPageBtn);
            this._nextPageBtn = null;
            ObjectUtils.disposeObject(this._endPageBtn);
            this._endPageBtn = null;
            ObjectUtils.disposeObject(this._topBtnsContainer);
            this._topBtnsContainer = null;
            ObjectUtils.disposeObject(this._rightItemLightMc);
            this._rightItemLightMc = null;
            ObjectUtils.disposeObject(this._shopSearchEndBtnBg);
            this._shopSearchEndBtnBg = null;
            ObjectUtils.disposeObject(this._shopSearchColseBtn);
            this._shopSearchColseBtn = null;
            ObjectUtils.disposeObject(this._shopSearchBox);
            this._shopSearchBox = null;
            ObjectUtils.disposeObject(this._goodItemContainerBg);
            this._goodItemContainerBg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package shop.view

