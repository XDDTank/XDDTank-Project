// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.BagView

package bagAndInfo.bag
{
    import flash.display.Sprite;
    import flash.display.Shape;
    import ddt.data.player.SelfInfo;
    import ddt.view.chat.ChatBugleInputFrame;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.manager.PlayerManager;
    import bagAndInfo.info.MoneyInfoView;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import changeColor.ChangeColorController;
    import bagAndInfo.ReworkName.ReworkNameFrame;
    import bagAndInfo.ReworkName.ReworkNameConsortia;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import bagAndInfo.PageOneSelectedButton;
    import bagAndInfo.PageTwoSelectedButton;
    import bagAndInfo.PageThreeSelectedButton;
    import ddt.view.tips.OneLineTip;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.OutMainListPanel;
    import ddt.data.BagInfo;
    import com.pickgliss.ui.controls.SelectedButton;
    import flash.utils.Timer;
    import baglocked.BagLockedController;
    import ddt.data.goods.InventoryItemInfo;
    import bagAndInfo.cell.LockBagCell;
    import com.pickgliss.ui.ComponentFactory;
    import flash.utils.getTimer;
    import bagAndInfo.BagAndInfoManager;
    import ddt.data.goods.Price;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SoundManager;
    import ddt.events.BagEvent;
    import ddt.manager.MessageTipManager;
    import ddt.events.CellEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import flash.utils.Dictionary;
    import ddt.data.EquipType;
    import bagAndInfo.info.PlayerViewState;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import road7th.comm.PackageIn;
    import ddt.manager.ItemManager;
    import ddt.view.bossbox.AwardsView;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.DropGoodsManager;
    import ddt.events.PlayerPropertyEvent;
    import ddt.manager.SharedManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.utils.ObjectUtils;
    import flash.ui.Mouse;
    import bagAndInfo.cell.BagCell;
    import baglocked.BaglockedManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import road7th.utils.DateUtils;
    import ddt.manager.TimeManager;
    import ddt.view.UIModuleSmallLoading;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import vip.VipController;
    import ddt.view.bossbox.PetBlessView;
    import pet.date.PetInfo;
    import ddt.manager.ShopManager;
    import ddt.view.goods.AddPricePanel;
    import ddt.command.OpenAllFrame;
    import flash.filters.GlowFilter;
    import bagAndInfo.changeSex.ChangeSexAlertFrame;
    import com.pickgliss.events.ComponentEvent;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.ui.controls.alert.SimpleAlert;
    import flash.external.ExternalInterface;

    [Event(name="sellstart")]
    [Event(name="sellstop")]
    public class BagView extends Sprite 
    {

        public static const TABCHANGE:String = "tabChange";
        public static const SHOWBEAD:String = "showBeadFrame";
        public static const EQUIP:int = 0;
        public static const PROP:int = 1;
        public static const CONSORTION:int = 3;
        private static const UseColorShellLevel:int = 10;

        private const STATE_SELL:uint = 1;
        private const _TRIEVENEEDLEVEL:int = 16;

        private var _index:int = 0;
        protected var _bgShape:Shape;
        private var state:uint = 0;
        protected var _info:SelfInfo;
        protected var _equiplist:BagEquipListView;
        protected var _equiplist1:BagEquipListView;
        protected var _equiplist2:BagEquipListView;
        protected var _currEquipIndex:int = 1;
        protected var _sellBtn:SellGoodsBtn;
        protected var _continueBtn:ContinueGoodsBtn;
        protected var _currentList:BagListView;
        protected var _breakBtn:BreakGoodsBtn;
        private var _chatBugleInputFrame:ChatBugleInputFrame;
        protected var _currentPage:int = 1;
        private var _lockPageNeedMoney:int;
        private var startIndex:int;
        private var stopIndex:int;
        protected var _bagType:int;
        protected var _settedLockBtn:BaseButton;
        protected var _settingLockBtn:BaseButton;
        private var _bagLocked:Boolean;
        protected var _sortBagBtn:TextButton;
        private var _self:SelfInfo = PlayerManager.Instance.Self;
        protected var _moneyView:MoneyInfoView;
        protected var _ddtmoneyView:MoneyInfoView;
        protected var _goldView:MoneyInfoView;
        protected var _bg:Scale9CornerImage;
        protected var _bg1:Scale9CornerImage;
        protected var _goodsNumInfoBg:Bitmap;
        protected var _goodsNumInfoText:FilterFrameText;
        protected var _goodsNumTotalText:FilterFrameText;
        private var _changeColorController:ChangeColorController;
        private var _reworknameView:ReworkNameFrame;
        private var _consortaiReworkName:ReworkNameConsortia;
        private var _baseAlerFrame:BaseAlerFrame;
        private var _openBagLock:Boolean = false;
        protected var _onePageBtn:PageOneSelectedButton;
        protected var _TwoPageBtn:PageTwoSelectedButton;
        protected var _ThreePageBtn:PageThreeSelectedButton;
        protected var _pageTips:OneLineTip;
        protected var _pageTipsI:OneLineTip;
        protected var _pageBtnSprite:Sprite;
        protected var _pageBtnSpriteI:Sprite;
        private var _PageBtnGroup:SelectedButtonGroup;
        private var _isScreenTexp:Boolean = false;
        private var _bagList:OutMainListPanel;
        private var _disEnabledFilters:Array;
        private var _equipBag:BagInfo;
        protected var _allClassBtn:SelectedButton;
        protected var _equipClassBtn:SelectedButton;
        protected var _fashionClassBtn:SelectedButton;
        protected var _propClassBtn:SelectedButton;
        protected var _questClassBtn:SelectedButton;
        private var _ClassBtnGroup:SelectedButtonGroup;
        private var _loadListTimer:Timer;
        private var infos:Array;
        private var _frame:BaseAlerFrame;
        private var clickSign:int = 0;
        private var _bagLockControl:BagLockedController;
        private var temInfo:InventoryItemInfo;
        private var _currentCell:LockBagCell;

        public function BagView()
        {
            this.init();
            this.initEvent();
        }

        public function get bagType():int
        {
            return (this._bagType);
        }

        protected function init():void
        {
            this.initBackGround();
            this.initBagList();
            this.initMoneyTexts();
            this.initButtons();
            this.initGoodsNumInfo();
            this.initClassButton();
            this.initPageButton();
            this.set_breakBtn_enable();
            this.set_text_location();
            this.set_btn_location();
            this.setBagType(EQUIP);
        }

        protected function initBackGround():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("bagBGAsset4");
            addChild(this._bg);
            this._bg1 = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.view.bgIII");
            addChild(this._bg1);
            this._bgShape = new Shape();
            this._bgShape.graphics.beginFill(15262671, 1);
            this._bgShape.graphics.drawRoundRect(0, 0, 327, 328, 2, 2);
            this._bgShape.graphics.endFill();
            this._bgShape.x = 11;
            this._bgShape.y = 50;
        }

        protected function initBagList():void
        {
            var _local_1:uint = getTimer();
            this._equiplist = BagAndInfoManager.Instance.bagListView;
            this._equiplist1 = BagAndInfoManager.Instance.bagListViewTwo;
            this._equiplist2 = BagAndInfoManager.Instance.bagListViewThree;
            this._equiplist.x = (this._equiplist1.x = (this._equiplist2.x = 12));
            this._equiplist.y = (this._equiplist1.y = (this._equiplist2.y = 54));
            this._equiplist.width = (this._equiplist1.width = (this._equiplist2.width = 330));
            this._equiplist.height = (this._equiplist2.height = (this._equiplist2.height = 320));
            this._equiplist1.visible = false;
            this._equiplist2.visible = false;
            addChild(this._equiplist);
            addChild(this._equiplist1);
            addChild(this._equiplist2);
        }

        private function initMoneyTexts():void
        {
            this._moneyView = new MoneyInfoView(Price.MONEY);
            this._ddtmoneyView = new MoneyInfoView(Price.DDT_MONEY);
            this._goldView = new MoneyInfoView(Price.GOLD);
            addChild(this._moneyView);
            addChild(this._ddtmoneyView);
            addChild(this._goldView);
            PositionUtils.setPos(this._moneyView, "MoneyInfoView.pos1");
            PositionUtils.setPos(this._ddtmoneyView, "MoneyInfoView.pos2");
            PositionUtils.setPos(this._goldView, "MoneyInfoView.pos3");
        }

        protected function initButtons():void
        {
            this._sellBtn = ComponentFactory.Instance.creatComponentByStylename("bagSellButton1");
            this._sellBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagSell");
            addChild(this._sellBtn);
            this._continueBtn = ComponentFactory.Instance.creatComponentByStylename("bagContinueButton1");
            this._continueBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagContinue");
            addChild(this._continueBtn);
            this._breakBtn = ComponentFactory.Instance.creatComponentByStylename("bagBreakButton1");
            this._breakBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagBreak");
            addChild(this._breakBtn);
            this._breakBtn.filters = null;
            this._breakBtn.enable = true;
            this._settingLockBtn = ComponentFactory.Instance.creatComponentByStylename("bagSetPWDButton1");
            this._settingLockBtn.tipData = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.BagLockedSetFrame.titleText");
            addChild(this._settingLockBtn);
            this._settedLockBtn = ComponentFactory.Instance.creatComponentByStylename("bagSetPWDButton1");
            this._settedLockBtn.tipData = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.BagLockedSetFrame.titleText");
            addChild(this._settedLockBtn);
            this._sortBagBtn = ComponentFactory.Instance.creatComponentByStylename("sortBagButton1");
            this._sortBagBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.sortBag");
            this._sortBagBtn.tipData = LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.bagFinishingBtn");
            this._sortBagBtn.filters = null;
            this._sortBagBtn.enable = true;
            addChild(this._sortBagBtn);
        }

        public function set sortBagEnable(_arg_1:Boolean):void
        {
            this._sortBagBtn.enable = _arg_1;
        }

        public function set breakBtnEnable(_arg_1:Boolean):void
        {
            this._breakBtn.enable = _arg_1;
            this._continueBtn.enable = _arg_1;
            this._sellBtn.enable = _arg_1;
        }

        public function set sellBtnFilter(_arg_1:Array):void
        {
            this._sellBtn.filters = _arg_1;
        }

        public function set sortBagFilter(_arg_1:Array):void
        {
            this._sortBagBtn.filters = _arg_1;
        }

        public function set breakBtnFilter(_arg_1:Array):void
        {
            this._breakBtn.filters = _arg_1;
            this._continueBtn.filters = _arg_1;
        }

        public function switchLockBtnVisible(_arg_1:Boolean):void
        {
            if (this._settedLockBtn)
            {
                this._settedLockBtn.visible = _arg_1;
            };
            if (this._settingLockBtn)
            {
                this._settingLockBtn.visible = _arg_1;
            };
        }

        public function switchButtomVisible(_arg_1:Boolean):void
        {
            this._sellBtn.visible = _arg_1;
            this._breakBtn.visible = _arg_1;
            this._continueBtn.visible = _arg_1;
            this._moneyView.visible = _arg_1;
            this._ddtmoneyView.visible = _arg_1;
            this._goldView.visible = _arg_1;
        }

        public function set switchbagViewBtn(_arg_1:Boolean):void
        {
            this._onePageBtn.visible = _arg_1;
            this._TwoPageBtn.visible = _arg_1;
            this._ThreePageBtn.visible = _arg_1;
        }

        private function initClassButton():void
        {
            this._allClassBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.AllBtn");
            addChild(this._allClassBtn);
            this._equipClassBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.EquipBtn");
            addChild(this._equipClassBtn);
            this._fashionClassBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.FashionBtn");
            addChild(this._fashionClassBtn);
            this._propClassBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.PropBtn");
            addChild(this._propClassBtn);
            this._questClassBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.QuestBtn");
            addChild(this._questClassBtn);
            this._ClassBtnGroup = new SelectedButtonGroup();
            this._ClassBtnGroup.addSelectItem(this._allClassBtn);
            this._ClassBtnGroup.addSelectItem(this._equipClassBtn);
            this._ClassBtnGroup.addSelectItem(this._fashionClassBtn);
            this._ClassBtnGroup.addSelectItem(this._propClassBtn);
            this._ClassBtnGroup.addSelectItem(this._questClassBtn);
            this._ClassBtnGroup.selectIndex = 0;
            this._ClassBtnGroup.addEventListener(Event.CHANGE, this.__changeClassHandler);
            this._allClassBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._equipClassBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._fashionClassBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._propClassBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._questClassBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
        }

        public function set setClassBtnEnable(_arg_1:Boolean):void
        {
            this._allClassBtn.enable = _arg_1;
            this._equipClassBtn.enable = _arg_1;
            this._fashionClassBtn.enable = _arg_1;
            this._propClassBtn.enable = _arg_1;
            this._questClassBtn.enable = _arg_1;
        }

        public function set setClassBtnVisible(_arg_1:Boolean):void
        {
            this._allClassBtn.visible = _arg_1;
            this._equipClassBtn.visible = _arg_1;
            this._fashionClassBtn.visible = _arg_1;
            this._propClassBtn.visible = _arg_1;
            this._questClassBtn.visible = _arg_1;
        }

        public function set setClassBtnFilter(_arg_1:Array):void
        {
            this._allClassBtn.filters = _arg_1;
            this._equipClassBtn.filters = _arg_1;
            this._fashionClassBtn.filters = _arg_1;
            this._propClassBtn.filters = _arg_1;
            this._questClassBtn.filters = _arg_1;
        }

        private function initPageButton():void
        {
            this._onePageBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.equipList.PageOneBtnAsset");
            this._onePageBtn.text = "1";
            addChild(this._onePageBtn);
            PositionUtils.setPos(this._onePageBtn, "ddtbagAndInfo.PageBtn.Pos");
            this._TwoPageBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.equipList.PageTwoBtnAsset");
            this._TwoPageBtn.text = "2";
            addChild(this._TwoPageBtn);
            PositionUtils.setPos(this._TwoPageBtn, "ddtbagAndInfo.PageBtn.Pos1");
            this._ThreePageBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.equipList.PageThreeBtnAsset");
            this._ThreePageBtn.text = "3";
            addChild(this._ThreePageBtn);
            PositionUtils.setPos(this._ThreePageBtn, "ddtbagAndInfo.PageBtn.Pos2");
            this._PageBtnGroup = new SelectedButtonGroup();
            this._PageBtnGroup.addSelectItem(this._onePageBtn);
            this._PageBtnGroup.addSelectItem(this._TwoPageBtn);
            this._PageBtnGroup.addSelectItem(this._ThreePageBtn);
            this._PageBtnGroup.selectIndex = 0;
            this._PageBtnGroup.addEventListener(Event.CHANGE, this.__changeHandler);
            this._onePageBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._TwoPageBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._ThreePageBtn.addEventListener(MouseEvent.CLICK, this.__soundPlay);
        }

        private function __mouseOverHandler(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            if (this._pageTips)
            {
                this._pageTips.visible = true;
                LayerManager.Instance.addToLayer(this._pageTips, LayerManager.GAME_TOP_LAYER);
                _local_2 = this._TwoPageBtn.localToGlobal(new Point(0, 0));
                this._pageTips.x = _local_2.x;
                this._pageTips.y = (_local_2.y + this._TwoPageBtn.height);
            };
        }

        private function __mouseOutHandler(_arg_1:MouseEvent):void
        {
            if (this._pageTips)
            {
                this._pageTips.visible = false;
            };
        }

        private function __mouseOverHandlerI(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            if (this._pageTipsI)
            {
                this._pageTipsI.visible = true;
                LayerManager.Instance.addToLayer(this._pageTipsI, LayerManager.GAME_TOP_LAYER);
                _local_2 = this._ThreePageBtn.localToGlobal(new Point(0, 0));
                this._pageTipsI.x = _local_2.x;
                this._pageTipsI.y = (_local_2.y + this._ThreePageBtn.height);
            };
        }

        private function __mouseOutHandlerI(_arg_1:MouseEvent):void
        {
            if (this._pageTipsI)
            {
                this._pageTipsI.visible = false;
            };
        }

        private function __soundPlay(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        public function initEquipBagPage():void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:int;
            var _local_1:int = int.MAX_VALUE;
            for each (_local_2 in this._info.Bag.items)
            {
                if (((_local_2.Place < _local_1) && (_local_2.Place > 30)))
                {
                    _local_1 = _local_2.Place;
                };
            };
            _local_3 = int((((_local_1 - 31) / 49) + 1));
            if (((_local_3 <= 0) || (_local_3 > 3)))
            {
                _local_3 = 1;
            };
            this._equiplist.visible = (_local_3 == 1);
            this._equiplist1.visible = (_local_3 == 2);
            this._equiplist2.visible = (_local_3 == 3);
            this._currentList = [this._equiplist, this._equiplist1, this._equiplist2][(_local_3 - 1)];
        }

        private function initGoodsNumInfo():void
        {
            this._goodsNumInfoText = ComponentFactory.Instance.creatComponentByStylename("bagGoodsInfoNumText");
            this._goodsNumTotalText = ComponentFactory.Instance.creatComponentByStylename("bagGoodsInfoNumTotalText");
            this._goodsNumTotalText.text = ("/ " + String((BagInfo.MAXPROPCOUNT + 1)));
        }

        public function hideForConsortia():void
        {
            removeChild(this._goodsNumInfoText);
            removeChild(this._goodsNumTotalText);
            removeChild(this._settingLockBtn);
            removeChild(this._settedLockBtn);
            removeChild(this._sortBagBtn);
        }

        private function updateView():void
        {
            this.updateMoney();
            this.updateBagList();
            this.updateLockState();
            this.updatePageBtn();
        }

        protected function updateBagList():void
        {
            var _local_1:uint = getTimer();
            if (this._info)
            {
                this.currentPage = this._currentPage;
                if (PlayerManager.Instance.Self.bagVibleType == 0)
                {
                    this._ClassBtnGroup.selectIndex = 0;
                };
            }
            else
            {
                this._equiplist.setData(null);
            };
        }

        protected function updateLockState():void
        {
            this._settingLockBtn.visible = (!(this._info.bagLocked));
            this._settedLockBtn.visible = this._info.bagLocked;
        }

        private function __clearHandler(_arg_1:BagEvent):void
        {
            this.updateLockState();
        }

        public function set sorGoodsEnabel(_arg_1:Boolean):void
        {
            this._sortBagBtn.enable = _arg_1;
        }

        private function __showBead(_arg_1:BagEvent):void
        {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.beadToBeadBag"));
        }

        protected function initEvent():void
        {
            PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE, this.__updateGoods);
            PlayerManager.Instance.addEventListener(PlayerManager.CHAGE_STATE, this.__changeState);
            this._sellBtn.addEventListener(MouseEvent.CLICK, this.__sellClick);
            this._breakBtn.addEventListener(MouseEvent.CLICK, this.__breakClick);
            this._equiplist.addEventListener(CellEvent.ITEM_CLICK, this.__cellEquipClick);
            this._equiplist.addEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
            this._equiplist.addEventListener(Event.CHANGE, this.__listChange);
            this._equiplist1.addEventListener(CellEvent.ITEM_CLICK, this.__cellEquipClick);
            this._equiplist1.addEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
            this._equiplist1.addEventListener(Event.CHANGE, this.__listChange);
            this._equiplist2.addEventListener(CellEvent.ITEM_CLICK, this.__cellEquipClick);
            this._equiplist2.addEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
            this._equiplist2.addEventListener(Event.CHANGE, this.__listChange);
            CellMenu.instance.addEventListener(CellMenu.ADDPRICE, this.__cellAddPrice);
            CellMenu.instance.addEventListener(CellMenu.MOVE, this.__cellMove);
            CellMenu.instance.addEventListener(CellMenu.OPEN, this.__cellOpen);
            CellMenu.instance.addEventListener(CellMenu.USE, this.__cellUse);
            CellMenu.instance.addEventListener(CellMenu.OPEN_ALL, this.__cellOpenAll);
            this._settingLockBtn.addEventListener(MouseEvent.CLICK, this.__openSettingLock);
            this._settedLockBtn.addEventListener(MouseEvent.CLICK, this.__openModifyLock);
            this._sortBagBtn.addEventListener(MouseEvent.CLICK, this.__sortBagClick);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL, this.__useColorShell);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_OPENUP, this.__openPreviewListFrame);
            this.adjustEvent();
        }

        protected function __updateGoods(_arg_1:BagEvent):void
        {
            var _local_2:Dictionary;
            var _local_3:Object;
            var _local_4:int;
            var _local_5:InventoryItemInfo;
            if (PlayerManager.Instance.Self.bagVibleType == 0)
            {
                this.updateBagList();
            }
            else
            {
                _local_2 = _arg_1.changedSlots;
                for (_local_3 in _local_2)
                {
                    _local_4 = this.findItemPlaceByPlace(int(_local_3));
                    if (this._equipBag.items[_local_4])
                    {
                        _local_5 = PlayerManager.Instance.Self.Bag.items[_local_3];
                        this._equiplist.setCellInfo(_local_4, _local_5);
                        if (this._equiplist1)
                        {
                            this._equiplist1.setCellInfo(_local_4, _local_5);
                        };
                        if (this._equiplist2)
                        {
                            this._equiplist2.setCellInfo(_local_4, _local_5);
                        };
                    };
                };
                this.updateBagList();
            };
        }

        private function findItemPlaceByPlace(_arg_1:int):int
        {
            var _local_2:Object;
            for (_local_2 in this._equipBag.items)
            {
                if (this._equipBag.items[_local_2].Place == _arg_1)
                {
                    return (int(_local_2));
                };
            };
            return (-1);
        }

        private function getEquipList(_arg_1:BagInfo, _arg_2:int):BagInfo
        {
            var _local_5:InventoryItemInfo;
            var _local_3:BagInfo = new BagInfo(BagInfo.EQUIPBAG, BagInfo.MAXPROPCOUNT);
            var _local_4:int = 30;
            for each (_local_5 in _arg_1.items)
            {
                if (_local_5.Place >= 31)
                {
                    if (_arg_2 == 0)
                    {
                        return (this._info.Bag);
                    };
                    if (_arg_2 == 1)
                    {
                        if (_local_5.CategoryID != 40) continue;
                        var _local_8:* = ++_local_4;
                        _local_3.items[_local_8] = _local_5;
                    }
                    else
                    {
                        if (_arg_2 == 2)
                        {
                            if ((!(EquipType.isFashionViewGoods(_local_5)))) continue;
                            _local_8 = ++_local_4;
                            _local_3.items[_local_8] = _local_5;
                        }
                        else
                        {
                            if (_arg_2 == 3)
                            {
                                if ((((_local_5.CategoryID == 40) || (EquipType.isFashionViewGoods(_local_5))) || ((_local_5.CategoryID == 11) && (_local_5.Property8 == "1")))) continue;
                                _local_8 = ++_local_4;
                                _local_3.items[_local_8] = _local_5;
                            }
                            else
                            {
                                if (_arg_2 == 4)
                                {
                                    if (((_local_5.CategoryID == 11) && (_local_5.Property8 == "1")))
                                    {
                                        _local_8 = ++_local_4;
                                        _local_3.items[_local_8] = _local_5;
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (_local_3);
        }

        private function __changeState(_arg_1:Event):void
        {
            if (PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
            {
                if (SavePointManager.Instance.isInSavePoint(64))
                {
                    this.fashionShowLight();
                    NewHandContainer.Instance.showArrow(ArrowType.CLICK_TO_EQUIP, 135, "trainer.ClickToEquipArrowPos2", "asset.trainer.clickToEquip", "trainer.ClickToEquipTipPos2", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                };
            };
        }

        private function __changeClassHandler(_arg_1:Event):void
        {
            switch (this._ClassBtnGroup.selectIndex)
            {
                case 0:
                    PlayerManager.Instance.Self.bagVibleType = 0;
                    this.initsortBag(true);
                    this.resetPageBtn();
                    break;
                case 1:
                    PlayerManager.Instance.Self.bagVibleType = 1;
                    this.initsortBag(false);
                    this.resetPageBtn();
                    break;
                case 2:
                    PlayerManager.Instance.Self.bagVibleType = 2;
                    this.initsortBag(false);
                    this.resetPageBtn();
                    break;
                case 3:
                    PlayerManager.Instance.Self.bagVibleType = 3;
                    this.initsortBag(false);
                    this.resetPageBtn();
                    break;
                case 4:
                    PlayerManager.Instance.Self.bagVibleType = 4;
                    this.initsortBag(false);
                    this.resetPageBtn();
            };
            this.updateBagList();
        }

        private function resetPageBtn():void
        {
            this._PageBtnGroup.selectIndex = 0;
            this.__changeHandler(null);
        }

        private function initsortBag(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._sortBagBtn.filters = null;
                this._sortBagBtn.enable = _arg_1;
                this._breakBtn.filters = null;
                this._breakBtn.enable = _arg_1;
            }
            else
            {
                this._sortBagBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                this._sortBagBtn.enable = _arg_1;
                this._breakBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                this._breakBtn.enable = _arg_1;
            };
        }

        private function __changeHandler(_arg_1:Event):void
        {
            switch (this._PageBtnGroup.selectIndex)
            {
                case 0:
                    this._equiplist.visible = true;
                    this._equiplist1.visible = false;
                    this._equiplist2.visible = false;
                    this._currentList = this._equiplist;
                    this.currentPage = 1;
                    return;
                case 1:
                    this._equiplist.visible = false;
                    this._equiplist1.visible = true;
                    this._equiplist2.visible = false;
                    this._currentList = this._equiplist1;
                    this.currentPage = 2;
                    return;
                case 2:
                    this._equiplist.visible = false;
                    this._equiplist1.visible = false;
                    this._equiplist2.visible = true;
                    this._currentList = this._equiplist2;
                    this.currentPage = 3;
                    return;
            };
        }

        private function setCurrPage(_arg_1:int):void
        {
        }

        protected function adjustEvent():void
        {
        }

        protected function __openPreviewListFrame(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_10:InventoryItemInfo;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:String = _local_2.readUTF();
            var _local_4:int = _local_2.readInt();
            this.infos = [];
            var _local_5:int;
            while (_local_5 < _local_4)
            {
                _local_10 = new InventoryItemInfo();
                _local_10.TemplateID = _local_2.readInt();
                _local_10 = ItemManager.fill(_local_10);
                _local_10.Count = _local_2.readInt();
                _local_10.IsBinds = _local_2.readBoolean();
                _local_10.ValidDate = _local_2.readInt();
                _local_10.StrengthenLevel = _local_2.readInt();
                _local_10.AttackCompose = _local_2.readInt();
                _local_10.DefendCompose = _local_2.readInt();
                _local_10.AgilityCompose = _local_2.readInt();
                _local_10.LuckCompose = _local_2.readInt();
                this.infos.push(_local_10);
                _local_5++;
            };
            var _local_6:int = _local_2.readInt();
            if (_local_6 > 0)
            {
                return;
            };
            if (this.infos.length == 0)
            {
                SocketManager.Instance.out.sendClearStoreBag();
                return;
            };
            var _local_7:AwardsView = new AwardsView();
            _local_7.goodsList = this.infos;
            _local_7.boxType = 4;
            var _local_8:FilterFrameText = ComponentFactory.Instance.creat("bagandinfo.awardsFFT");
            _local_8.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle");
            this._frame = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ItemPreviewListFrame");
            var _local_9:AlertInfo = new AlertInfo(_local_3);
            _local_9.showCancel = false;
            _local_9.moveEnable = false;
            this._frame.info = _local_9;
            this._frame.addToContent(_local_7);
            this._frame.addToContent(_local_8);
            this._frame.addEventListener(FrameEvent.RESPONSE, this.__frameClose);
            LayerManager.Instance.addToLayer(this._frame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __frameClose(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this._frame.removeEventListener(FrameEvent.RESPONSE, this.__frameClose);
                    SoundManager.instance.play("008");
                    (_arg_1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this.__frameClose);
                    (_arg_1.currentTarget as BaseAlerFrame).dispose();
                    SocketManager.Instance.out.sendClearStoreBag();
                    if ((!(PlayerManager.Instance.Self.Bag.itemBagFull())))
                    {
                        DropGoodsManager.play(this.infos);
                    };
                    return;
            };
        }

        protected function __useColorShell(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:Boolean = _local_2.readBoolean();
            if (_local_3)
            {
                SoundManager.instance.play("063");
            };
        }

        protected function removeEvents():void
        {
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE, this.__updateGoods);
            PlayerManager.Instance.removeEventListener(PlayerManager.CHAGE_STATE, this.__changeState);
            if (this._sellBtn)
            {
                this._sellBtn.removeEventListener(MouseEvent.CLICK, this.__sellClick);
            };
            if (this._breakBtn)
            {
                this._breakBtn.removeEventListener(MouseEvent.CLICK, this.__breakClick);
            };
            if (this._equiplist)
            {
                this._equiplist.removeEventListener(CellEvent.ITEM_CLICK, this.__cellEquipClick);
            };
            if (this._equiplist)
            {
                this._equiplist.removeEventListener(Event.CHANGE, this.__listChange);
            };
            if (this._equiplist)
            {
                this._equiplist.removeEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
            };
            if (this._equiplist1)
            {
                this._equiplist1.removeEventListener(CellEvent.ITEM_CLICK, this.__cellEquipClick);
            };
            if (this._equiplist1)
            {
                this._equiplist1.removeEventListener(Event.CHANGE, this.__listChange);
            };
            if (this._equiplist1)
            {
                this._equiplist1.removeEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
            };
            if (this._equiplist2)
            {
                this._equiplist2.removeEventListener(CellEvent.ITEM_CLICK, this.__cellEquipClick);
            };
            if (this._equiplist2)
            {
                this._equiplist2.removeEventListener(Event.CHANGE, this.__listChange);
            };
            if (this._equiplist2)
            {
                this._equiplist2.removeEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
            };
            if (this._PageBtnGroup)
            {
                this._PageBtnGroup.removeEventListener(Event.CHANGE, this.__changeHandler);
            };
            if (this._onePageBtn)
            {
                this._onePageBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            };
            if (this._ClassBtnGroup)
            {
                this._ClassBtnGroup.removeEventListener(Event.CHANGE, this.__changeClassHandler);
            };
            if (this._TwoPageBtn)
            {
                this._TwoPageBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            };
            if (this._ThreePageBtn)
            {
                this._ThreePageBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            };
            if (this._pageBtnSprite)
            {
                this._pageBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
                this._pageBtnSprite.removeEventListener(MouseEvent.ROLL_OUT, this.__mouseOutHandler);
            };
            if (this._pageBtnSpriteI)
            {
                this._pageBtnSpriteI.removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandlerI);
                this._pageBtnSpriteI.removeEventListener(MouseEvent.ROLL_OUT, this.__mouseOutHandlerI);
            };
            if (this._sortBagBtn)
            {
                this._sortBagBtn.removeEventListener(MouseEvent.CLICK, this.__sortBagClick);
            };
            CellMenu.instance.removeEventListener(CellMenu.ADDPRICE, this.__cellAddPrice);
            CellMenu.instance.removeEventListener(CellMenu.MOVE, this.__cellMove);
            CellMenu.instance.removeEventListener(CellMenu.OPEN, this.__cellOpen);
            CellMenu.instance.removeEventListener(CellMenu.USE, this.__cellUse);
            CellMenu.instance.removeEventListener(CellMenu.OPEN_ALL, this.__cellOpenAll);
            if (this._settingLockBtn)
            {
                this._settingLockBtn.removeEventListener(MouseEvent.CLICK, this.__openSettingLock);
            };
            if (this._settedLockBtn)
            {
                this._settedLockBtn.removeEventListener(MouseEvent.CLICK, this.__openModifyLock);
            };
            PlayerManager.Instance.Self.removeEventListener(BagEvent.CLEAR, this.__clearHandler);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.AFTERDEL, this.__clearHandler);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.CHANGEPSW, this.__clearHandler);
            PlayerManager.Instance.Self.removeEventListener(BagEvent.SHOW_BEAD, this.__showBead);
            if (this._info)
            {
                this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
                this._info.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE, this.__onBagUpdateEQUIPBAG);
            };
            if (this._bagLockControl)
            {
                this._bagLockControl.addEventListener(Event.COMPLETE, this.__onLockComplete);
            };
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.USE_COLOR_SHELL, this.__useColorShell);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_OPENUP, this.__openPreviewListFrame);
        }

        public function setBagType(_arg_1:int):void
        {
            if (_arg_1 == EQUIP)
            {
                if (((this._equiplist) && (this.currentPage == 1)))
                {
                    this._currentList = this._equiplist;
                }
                else
                {
                    if (((this._equiplist1) && (this.currentPage == 2)))
                    {
                        this._currentList = this._equiplist1;
                    }
                    else
                    {
                        if (((this._equiplist1) && (this.currentPage == 3)))
                        {
                            this._currentList = this._equiplist2;
                        };
                    };
                };
            };
            if (this._equiplist)
            {
                this._equiplist.visible = ((this._bagType == EQUIP) && (!(this._isScreenTexp)));
                if ((((this._equiplist.visible) && (this.currentPage == 1)) && (!(this._isScreenTexp))))
                {
                    this._equiplist1.visible = (this._bagType == EQUIP);
                    this._equiplist2.visible = (this._bagType == EQUIP);
                    this._equiplist1.visible = false;
                    this._equiplist2.visible = false;
                    this._currentList = this._equiplist;
                    this._PageBtnGroup.selectIndex = 0;
                }
                else
                {
                    if (((this.currentPage == 2) && (!(this._isScreenTexp))))
                    {
                        this._equiplist.visible = (this._bagType == EQUIP);
                        this._equiplist.visible = false;
                        this._equiplist1.visible = (this._bagType == EQUIP);
                        this._equiplist2.visible = (this._bagType == EQUIP);
                        this._equiplist2.visible = false;
                        this._currentList = this._equiplist1;
                        this._PageBtnGroup.selectIndex = 1;
                    }
                    else
                    {
                        if (((this.currentPage == 3) && (!(this._isScreenTexp))))
                        {
                            this._equiplist.visible = (this._bagType == EQUIP);
                            this._equiplist.visible = false;
                            this._equiplist1.visible = (this._bagType == EQUIP);
                            this._equiplist1.visible = false;
                            this._equiplist2.visible = (this._bagType == EQUIP);
                            this._currentList = this._equiplist2;
                            this._PageBtnGroup.selectIndex = 2;
                        };
                    };
                };
            };
            if (this._bagType == _arg_1)
            {
                if (((this._bagType == EQUIP) && (!(this._isScreenTexp))))
                {
                    if (SavePointManager.Instance.savePoints[34])
                    {
                        this._sellBtn.filters = null;
                        this._continueBtn.filters = null;
                    };
                };
                if (this._bagType == PROP)
                {
                    this._continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                };
                return;
            };
            this._bagType = _arg_1;
            dispatchEvent(new Event(TABCHANGE));
            this._bgShape.visible = ((this._bagType == EQUIP) || (this._bagType == PROP));
            this._equiplist.visible = ((this._bagType == EQUIP) && (!(this._isScreenTexp)));
            this._equiplist1.visible = ((this._bagType == EQUIP) && (!(this._isScreenTexp)));
            this._equiplist2.visible = ((this._bagType == EQUIP) && (!(this._isScreenTexp)));
            this.set_breakBtn_enable();
            if (((this._bagType == EQUIP) && (!(this._isScreenTexp))))
            {
                this._sellBtn.filters = null;
                this._continueBtn.filters = null;
                this.initEquipBagPage();
            };
            if (this._bagType == PROP)
            {
                this._continueBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        protected function set_breakBtn_enable():void
        {
        }

        protected function set_text_location():void
        {
        }

        protected function set_btn_location():void
        {
        }

        private function __onBagUpdateEQUIPBAG(_arg_1:BagEvent):void
        {
            this.setBagCountShow(BagInfo.EQUIPBAG);
        }

        private function __onBagUpdatePROPBAG(_arg_1:BagEvent):void
        {
            if (((!(this.bagType == 21)) && (!(this.bagType == 2))))
            {
                this.setBagCountShow(BagInfo.PROPBAG);
            };
        }

        private function __openSettingLock(_arg_1:MouseEvent):void
        {
            if (this._openBagLock)
            {
                return;
            };
            SoundManager.instance.play("008");
            if ((!(this._bagLockControl)))
            {
                this._bagLockControl = new BagLockedController();
            };
            this._openBagLock = true;
            this._bagLockControl.show();
            this._bagLockControl.addEventListener(Event.COMPLETE, this.__onLockComplete);
            SharedManager.Instance.setBagLocked = true;
            SharedManager.Instance.save();
        }

        private function __openModifyLock(_arg_1:MouseEvent):void
        {
            if (this._openBagLock)
            {
                return;
            };
            SoundManager.instance.play("008");
            if ((!(this._bagLockControl)))
            {
                this._bagLockControl = new BagLockedController();
            };
            this._bagLockControl.show();
            this._openBagLock = true;
            this._bagLockControl.addEventListener(Event.COMPLETE, this.__onLockComplete);
            SharedManager.Instance.setBagLocked = true;
            SharedManager.Instance.save();
        }

        private function __onLockComplete(_arg_1:Event):void
        {
            this._bagLockControl.removeEventListener(Event.COMPLETE, this.__onLockComplete);
            this._openBagLock = false;
        }

        protected function __sortBagClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:String = LanguageMgr.GetTranslation("bagAndInfo.bag.sortBagClick.isSegistration");
            AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), _local_2, LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND).addEventListener(FrameEvent.RESPONSE, this.__frameEvent);
        }

        private function __frameEvent(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            _local_2.dispose();
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    PlayerManager.Instance.Self.PropBag.sortBag(this._bagType, PlayerManager.Instance.Self.getBag(this._bagType), 31, 86, true);
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    PlayerManager.Instance.Self.PropBag.sortBag(this._bagType, PlayerManager.Instance.Self.getBag(this._bagType), 0, 48, false);
                    return;
            };
        }

        private function __propertyChange(_arg_1:PlayerPropertyEvent):void
        {
            if (((((_arg_1.changedProperties[PlayerInfo.MONEY]) || (_arg_1.changedProperties[PlayerInfo.GOLD])) || (_arg_1.changedProperties[PlayerInfo.DDT_MONEY])) || (_arg_1.changedProperties[PlayerInfo.MEDAL])))
            {
                this.updateMoney();
            }
            else
            {
                if (_arg_1.changedProperties["bagLocked"])
                {
                    this._bagLocked = this._info.bagLocked;
                    this.updateLockState();
                };
            };
            this.updatePageBtn();
        }

        private function updateMoney():void
        {
            if (this._info)
            {
                this._moneyView.setInfo(this._info);
                this._ddtmoneyView.setInfo(this._info);
                this._goldView.setInfo(this._info);
            };
        }

        private function updatePageBtn():void
        {
            if (PlayerManager.Instance.Self.Grade < 20)
            {
                this._TwoPageBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                if ((!(this._pageBtnSprite)))
                {
                    this._pageBtnSprite = new Sprite();
                    this._pageBtnSprite.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
                    this._pageBtnSprite.addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
                    this._pageBtnSprite.graphics.beginFill(0, 0);
                    this._pageBtnSprite.graphics.drawRect(0, 0, this._TwoPageBtn.displayWidth, this._TwoPageBtn.displayHeight);
                    this._pageBtnSprite.graphics.endFill();
                    this._pageBtnSprite.x = this._TwoPageBtn.x;
                    this._pageBtnSprite.y = this._TwoPageBtn.y;
                    addChild(this._pageBtnSprite);
                };
                if (this._pageTips == null)
                {
                    this._pageTips = new OneLineTip();
                    this._pageTips.tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.UnLockPage20");
                    this._pageTips.visible = false;
                };
            }
            else
            {
                this._TwoPageBtn.filters = null;
                this._TwoPageBtn.enable = true;
                if (this._pageTips)
                {
                    ObjectUtils.disposeObject(this._pageTips);
                    this._pageTips = null;
                };
                if (this._pageBtnSprite)
                {
                    ObjectUtils.disposeObject(this._pageBtnSprite);
                    this._pageBtnSprite = null;
                };
            };
            if (PlayerManager.Instance.Self.Grade < 30)
            {
                this._ThreePageBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                this._ThreePageBtn.enable = false;
                if ((!(this._pageBtnSpriteI)))
                {
                    this._pageBtnSpriteI = new Sprite();
                    this._pageBtnSpriteI.addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandlerI);
                    this._pageBtnSpriteI.addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandlerI);
                    this._pageBtnSpriteI.graphics.beginFill(0, 0);
                    this._pageBtnSpriteI.graphics.drawRect(0, 0, this._ThreePageBtn.displayWidth, this._ThreePageBtn.displayHeight);
                    this._pageBtnSpriteI.graphics.endFill();
                    this._pageBtnSpriteI.x = this._ThreePageBtn.x;
                    this._pageBtnSpriteI.y = this._ThreePageBtn.y;
                    addChild(this._pageBtnSpriteI);
                };
                if (this._pageTipsI == null)
                {
                    this._pageTipsI = new OneLineTip();
                    this._pageTipsI.tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.UnLockPage30");
                    this._pageTipsI.visible = false;
                };
            }
            else
            {
                this._ThreePageBtn.filters = null;
                this._ThreePageBtn.enable = true;
                if (this._pageTipsI)
                {
                    ObjectUtils.disposeObject(this._pageTipsI);
                    this._pageTipsI = null;
                };
                if (this._pageBtnSpriteI)
                {
                    ObjectUtils.disposeObject(this._pageBtnSpriteI);
                    this._pageBtnSpriteI = null;
                };
            };
        }

        protected function __listChange(_arg_1:Event):void
        {
            if (this._isScreenTexp)
            {
                this.setBagType(BagInfo.PROPBAG);
            }
            else
            {
                this.setBagType(BagInfo.EQUIPBAG);
            };
        }

        private function __sellClick(_arg_1:MouseEvent):void
        {
            if (this.currentPage == 1)
            {
                this._equiplist.visible = true;
                this._equiplist1.visible = false;
                this._equiplist2.visible = false;
            }
            else
            {
                if (this.currentPage == 2)
                {
                    this._equiplist.visible = false;
                    this._equiplist1.visible = true;
                    this._equiplist2.visible = false;
                }
                else
                {
                    this._equiplist.visible = false;
                    this._equiplist1.visible = false;
                    this._equiplist2.visible = true;
                };
            };
            if ((!(this.state & this.STATE_SELL)))
            {
                Mouse.hide();
                this.state = (this.state | this.STATE_SELL);
                SoundManager.instance.play("008");
                this._sellBtn.dragStart(_arg_1.stageX, _arg_1.stageY);
                this._sellBtn.addEventListener(SellGoodsBtn.StopSell, this.__stopSell);
                dispatchEvent(new Event("sellstart"));
                stage.addEventListener(MouseEvent.CLICK, this.__onStageClick_SellBtn);
                _arg_1.stopImmediatePropagation();
            }
            else
            {
                this.state = ((~(this.STATE_SELL)) & this.state);
                this._sellBtn.stopDrag();
            };
        }

        private function __stopSell(_arg_1:Event):void
        {
            this.state = ((~(this.STATE_SELL)) & this.state);
            this._sellBtn.removeEventListener(SellGoodsBtn.StopSell, this.__stopSell);
            dispatchEvent(new Event("sellstop"));
            if (stage)
            {
                stage.removeEventListener(MouseEvent.CLICK, this.__onStageClick_SellBtn);
            };
        }

        private function __onStageClick_SellBtn(_arg_1:Event):void
        {
            this.state = ((~(this.STATE_SELL)) & this.state);
            dispatchEvent(new Event("sellstop"));
            if (stage)
            {
                stage.removeEventListener(MouseEvent.CLICK, this.__onStageClick_SellBtn);
            };
        }

        private function __breakClick(_arg_1:MouseEvent):void
        {
            if (this._breakBtn.enable)
            {
                SoundManager.instance.play("008");
                Mouse.hide();
                this._breakBtn.dragStart(_arg_1.stageX, _arg_1.stageY);
            };
        }

        public function resetMouse():void
        {
            this.state = ((~(this.STATE_SELL)) & this.state);
            LayerManager.Instance.clearnStageDynamic();
            Mouse.show();
            if (this._breakBtn)
            {
                this._breakBtn.stopDrag();
            };
        }

        private function isOnlyGivingGoods(_arg_1:InventoryItemInfo):Boolean
        {
            return (((_arg_1.IsBinds == false) && (EquipType.isPackage(_arg_1))) && (_arg_1.Property2 == "10"));
        }

        protected function __cellEquipClick(_arg_1:CellEvent):void
        {
            var _local_2:*;
            var _local_3:InventoryItemInfo;
            var _local_4:Point;
            var _local_5:Point;
            if ((!(this._sellBtn.isActive)))
            {
                _arg_1.stopImmediatePropagation();
                if ((_arg_1.data is LockBagCell))
                {
                    _local_2 = (_arg_1.data as LockBagCell);
                };
                if (_local_2)
                {
                    _local_3 = (_local_2.itemInfo as InventoryItemInfo);
                };
                if (_local_3 == null)
                {
                    return;
                };
                if ((!(_local_2.locked)))
                {
                    SoundManager.instance.play("008");
                    if (((!(this.isOnlyGivingGoods(_local_3))) && (((((_local_3.getRemainDate() <= 0) && (!(EquipType.isProp(_local_3)))) || (EquipType.isPackage(_local_3))) || ((_local_3.getRemainDate() <= 0) && (_local_3.TemplateID == 10200))) || (EquipType.canBeUsed(_local_3)))))
                    {
                        _local_4 = localToGlobal(new Point(_local_2.x, _local_2.y));
                        CellMenu.instance.show(_local_2, (_local_4.x + 35), (_local_4.y + 77));
                    }
                    else
                    {
                        if (_local_3.CategoryID == 41)
                        {
                            _local_5 = localToGlobal(new Point(_local_2.x, _local_2.y));
                            CellMenu.instance.show(_local_2, (_local_5.x + 35), (_local_5.y + 77));
                        }
                        else
                        {
                            _local_2.dragStart();
                        };
                    };
                };
            };
        }

        protected function __cellClick(_arg_1:CellEvent):void
        {
            var _local_2:*;
            var _local_3:InventoryItemInfo;
            var _local_4:Point;
            var _local_5:Point;
            if ((!(this._sellBtn.isActive)))
            {
                _arg_1.stopImmediatePropagation();
                if ((_arg_1.data is LockBagCell))
                {
                    _local_2 = (_arg_1.data as LockBagCell);
                }
                else
                {
                    if ((_arg_1.data is BagCell))
                    {
                        _local_2 = (_arg_1.data as BagCell);
                    };
                };
                if (_local_2)
                {
                    _local_3 = (_local_2.itemInfo as InventoryItemInfo);
                };
                if (_local_3 == null)
                {
                    return;
                };
                if ((!(_local_2.locked)))
                {
                    SoundManager.instance.play("008");
                    if (((!(this.isOnlyGivingGoods(_local_3))) && (((((_local_3.getRemainDate() <= 0) && (!(EquipType.isProp(_local_3)))) || (EquipType.isPackage(_local_3))) || ((_local_3.getRemainDate() <= 0) && (_local_3.TemplateID == 10200))) || (EquipType.canBeUsed(_local_3)))))
                    {
                        _local_4 = localToGlobal(new Point(_local_2.x, _local_2.y));
                        CellMenu.instance.show(_local_2, (_local_4.x + 35), (_local_4.y + 77));
                    }
                    else
                    {
                        if (_local_3.CategoryID == 41)
                        {
                            _local_5 = localToGlobal(new Point(_local_2.x, _local_2.y));
                            CellMenu.instance.show(_local_2, (_local_5.x + 35), (_local_5.y + 77));
                        }
                        else
                        {
                            _local_2.dragStart();
                        };
                    };
                };
            };
        }

        public function set cellDoubleClickEnable(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._equiplist.addEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
            }
            else
            {
                this._equiplist.removeEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
            };
        }

        public function unlockBagCells():void
        {
            this._equiplist.unlockAllCells();
        }

        public function weaponShowLight():void
        {
            this._equiplist.weaponShowLight();
        }

        public function fashionShowLight():void
        {
            this._equiplist.fashionEquipShine();
        }

        protected function __cellDoubleClick(_arg_1:CellEvent):void
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:BaseAlerFrame;
            var _local_10:Number;
            var _local_11:Date;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:BaseAlerFrame;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            _arg_1.stopImmediatePropagation();
            var _local_2:LockBagCell = (_arg_1.data as LockBagCell);
            var _local_3:InventoryItemInfo = (_local_2.info as InventoryItemInfo);
            var _local_4:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_local_3.TemplateID);
            var _local_5:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_local_3.TemplateID);
            var _local_6:int = ((PlayerManager.Instance.Self.Sex) ? 1 : 2);
            if (_local_3.getRemainDate() <= 0)
            {
                return;
            };
            if ((!(_local_2.locked)))
            {
                if (EquipType.isEquipViewGoods(_local_3))
                {
                    _local_7 = PlayerManager.Instance.getEquipPlace(_local_3);
                }
                else
                {
                    _local_8 = PlayerManager.Instance.getDressEquipPlace(_local_3);
                };
                if (_local_5)
                {
                    if (_local_3.NeedLevel > PlayerManager.Instance.Self.Grade)
                    {
                        return (MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.need")));
                    };
                };
                if (((((((_local_2.info.BindType == 1) || (_local_2.info.BindType == 2)) || (_local_2.info.BindType == 3)) && (_local_2.itemInfo.IsBinds == false)) && (!(EquipType.isPackage(_local_3)))) && (!(EquipType.canBeUsed(_local_3)))))
                {
                    _local_9 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
                    _local_9.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
                    this.temInfo = _local_3;
                }
                else
                {
                    if (((!(PlayerManager.Instance.playerstate == PlayerViewState.FASHION)) && (EquipType.isFashionViewGoods(_local_3))))
                    {
                        PlayerManager.Instance.changeState(PlayerViewState.FASHION);
                        SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, _local_3.Place, BagInfo.EQUIPBAG, _local_8, _local_3.Count);
                    }
                    else
                    {
                        if (EquipType.isRingEquipment(_local_3))
                        {
                            PlayerManager.Instance.changeState(PlayerViewState.FASHION);
                            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, _local_3.Place, BagInfo.EQUIPBAG, _local_7, _local_3.Count);
                        }
                        else
                        {
                            if (((!(PlayerManager.Instance.playerstate == PlayerViewState.EQUIP)) && (EquipType.isEquipViewGoods(_local_3))))
                            {
                                PlayerManager.Instance.changeState(PlayerViewState.EQUIP);
                                SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, _local_3.Place, BagInfo.EQUIPBAG, _local_7, _local_3.Count);
                            }
                            else
                            {
                                SoundManager.instance.play("008");
                                if ((((_local_3.TemplateID == EquipType.SUPER_EXP) || (_local_3.TemplateID == EquipType.PET_ADVANCE)) || (_local_3.TemplateID == EquipType.PET_EXP)))
                                {
                                    this.useCard(_local_3);
                                }
                                else
                                {
                                    if (((_local_2.info.CategoryID == 11) && (_local_2.info.Property1 == "34")))
                                    {
                                        this.usePetBless(_local_2.itemInfo);
                                    }
                                    else
                                    {
                                        if (EquipType.isPackage(_local_3))
                                        {
                                            _local_10 = ((PlayerManager.Instance.Self.Sex) ? 1 : 2);
                                            if (((!(_local_2.info.NeedSex == 0)) && (!(_local_10 == _local_2.info.NeedSex))))
                                            {
                                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.sexErr"));
                                                return;
                                            };
                                            if (PlayerManager.Instance.Self.Grade >= _local_2.info.NeedLevel)
                                            {
                                                if (EquipType.isTimeBox(_local_2.info))
                                                {
                                                    _local_11 = DateUtils.getDateByStr(InventoryItemInfo(_local_2.info).BeginDate);
                                                    _local_12 = int(((int(_local_2.info.Property3) * 60) - ((TimeManager.Instance.Now().time - _local_11.getTime()) / 1000)));
                                                    if (_local_12 <= 0)
                                                    {
                                                        SocketManager.Instance.out.sendItemOpenUp(_local_2.itemInfo.BagType, _local_2.itemInfo.Place);
                                                    }
                                                    else
                                                    {
                                                        _local_13 = int((_local_12 / 3600));
                                                        _local_14 = int(((_local_12 % 3600) / 60));
                                                        _local_14 = ((_local_14 > 0) ? _local_14 : 1);
                                                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.userGuild.boxTip", _local_13, _local_14));
                                                    };
                                                }
                                                else
                                                {
                                                    if (EquipType.isSpecilPackage(_local_2.info))
                                                    {
                                                        if (PlayerManager.Instance.Self.DDTMoney >= Number(_local_2.info.Property3))
                                                        {
                                                            _local_15 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBag", _local_2.info.Property3, _local_2.info.Name), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                                                            _local_15.addEventListener(FrameEvent.RESPONSE, this.__GiftBagframeClose);
                                                        }
                                                        else
                                                        {
                                                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBagII", _local_2.info.Property3));
                                                        };
                                                    }
                                                    else
                                                    {
                                                        SocketManager.Instance.out.sendItemOpenUp(_local_2.itemInfo.BagType, _local_2.itemInfo.Place);
                                                    };
                                                };
                                            }
                                            else
                                            {
                                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.level"));
                                            };
                                        }
                                        else
                                        {
                                            if (EquipType.canBeUsed(_local_3))
                                            {
                                                if (_local_2.info.TemplateID == EquipType.VITALITY_WATER)
                                                {
                                                    this.useCard(_local_2.itemInfo);
                                                    return;
                                                };
                                                if (_local_2.info.TemplateID == EquipType.REWORK_NAME)
                                                {
                                                    this.startReworkName(_local_2.bagType, _local_2.itemInfo.Place);
                                                    return;
                                                };
                                                if ((((_local_2.info.CategoryID == 11) && (_local_2.info.Property1 == "5")) && (!(_local_2.info.Property2 == "0"))))
                                                {
                                                    this.showChatBugleInputFrame(_local_2.info.TemplateID);
                                                    return;
                                                };
                                                if (((_local_2.info.CategoryID == 11) && (_local_2.info.Property1 == "34")))
                                                {
                                                    this.usePetBless(_local_2.itemInfo);
                                                    return;
                                                };
                                                if (_local_2.info.TemplateID == EquipType.CONSORTIA_REWORK_NAME)
                                                {
                                                    if (PlayerManager.Instance.Self.ConsortiaID == 0)
                                                    {
                                                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert1"));
                                                        return;
                                                    };
                                                    if (PlayerManager.Instance.Self.NickName != PlayerManager.Instance.Self.consortiaInfo.ChairmanName)
                                                    {
                                                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert2"));
                                                        return;
                                                    };
                                                    this.startupConsortiaReworkName(_local_2.bagType, _local_2.itemInfo.Place);
                                                    return;
                                                };
                                                if (_local_2.info.TemplateID == EquipType.CHANGE_SEX)
                                                {
                                                    this.startupChangeSex(_local_2.bagType, _local_2.itemInfo.Place);
                                                    return;
                                                };
                                                if (((_local_2.info.CategoryID == 11) && (int(_local_2.info.Property1) == 37)))
                                                {
                                                    if (PlayerManager.Instance.Self.Bag.getItemAt(6))
                                                    {
                                                        if (PlayerManager.Instance.Self.Bag.getItemAt(6).StrengthenLevel >= 10)
                                                        {
                                                            SocketManager.Instance.out.sendUseChangeColorShell(_local_2.bagType, _local_2.place);
                                                            return;
                                                        };
                                                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bagAndInfo.bag.UnableUseColorShell"));
                                                    }
                                                    else
                                                    {
                                                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.bagAndInfo.ColorShell.NoWeapon"));
                                                        return;
                                                    };
                                                };
                                                if (_local_2.info.TemplateID == EquipType.COLORCARD)
                                                {
                                                    if ((!(this._changeColorController)))
                                                    {
                                                        this._changeColorController = new ChangeColorController();
                                                    };
                                                    this._changeColorController.changeColorModel.place = _local_2.itemInfo.Place;
                                                    UIModuleSmallLoading.Instance.progress = 0;
                                                    UIModuleSmallLoading.Instance.show();
                                                    UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                                                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__changeColorProgress);
                                                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__changeColorComplete);
                                                    UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHANGECOLOR);
                                                }
                                                else
                                                {
                                                    if (_local_2.info.TemplateID != EquipType.TRANSFER_PROP)
                                                    {
                                                        if (_local_2.info.CategoryID == EquipType.COMPOSE_SKILL)
                                                        {
                                                            SocketManager.Instance.out.sendFormula(_local_2.itemInfo.Place);
                                                        }
                                                        else
                                                        {
                                                            if (((_local_2.info.CategoryID == 11) && (int(_local_2.info.Property1) == 100)))
                                                            {
                                                                this.useProp(_local_2.itemInfo);
                                                            }
                                                            else
                                                            {
                                                                this.useCard(_local_2.itemInfo);
                                                                if (_local_2.itemInfo.TemplateID == EquipType.VIPCARD_TEST)
                                                                {
                                                                    VipController.instance.show();
                                                                };
                                                            };
                                                        };
                                                    };
                                                };
                                            }
                                            else
                                            {
                                                if (PlayerManager.Instance.Self.canEquip(_local_3))
                                                {
                                                    if (PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
                                                    {
                                                        SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, _local_3.Place, BagInfo.EQUIPBAG, _local_8, _local_3.Count);
                                                    }
                                                    else
                                                    {
                                                        SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, _local_3.Place, BagInfo.EQUIPBAG, _local_7, _local_3.Count);
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        private function usePetBless(_arg_1:InventoryItemInfo):void
        {
            var _local_3:PetBlessView;
            var _local_2:PetInfo = PlayerManager.Instance.Self.pets[0];
            if (_local_2)
            {
                if ((int(((_local_2.TemplateID % 100000) / 10000)) + 1) == int(_arg_1.Property2))
                {
                    if (((_local_2.TemplateID % 1000) / 100) < 2)
                    {
                        _local_3 = ComponentFactory.Instance.creat("bagAndInfo.petBlessView");
                        _local_3.petInfo = _local_2;
                        _local_3.itemInfo = _arg_1;
                        LayerManager.Instance.addToLayer(_local_3, LayerManager.STAGE_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddtbagAndInfo.usePetBlessAlertFailed1Msg"));
                    };
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddtbagAndInfo.usePetBlessAlertFailed2Msg"));
                };
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddtbagAndInfo.usePetBlessAlertFailed3Msg"));
            };
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                this.sendDefy();
            };
        }

        private function sendDefy():void
        {
            var _local_1:int;
            var _local_2:int;
            SoundManager.instance.play("008");
            if (EquipType.isEquipViewGoods(this.temInfo))
            {
                _local_1 = PlayerManager.Instance.getEquipPlace(this.temInfo);
            }
            else
            {
                _local_2 = PlayerManager.Instance.getDressEquipPlace(this.temInfo);
            };
            if (((!(PlayerManager.Instance.playerstate == PlayerViewState.FASHION)) && ((EquipType.isFashionViewGoods(this.temInfo)) || (EquipType.isRingEquipment(this.temInfo)))))
            {
                PlayerManager.Instance.changeState(PlayerViewState.FASHION);
                SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, this.temInfo.Place, BagInfo.EQUIPBAG, _local_2, this.temInfo.Count);
            }
            else
            {
                if (((!(PlayerManager.Instance.playerstate == PlayerViewState.EQUIP)) && (!(EquipType.isFashionViewGoods(this.temInfo)))))
                {
                    PlayerManager.Instance.changeState(PlayerViewState.EQUIP);
                    SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, this.temInfo.Place, BagInfo.EQUIPBAG, _local_1, this.temInfo.Count);
                }
                else
                {
                    SoundManager.instance.play("008");
                    if (PlayerManager.Instance.Self.canEquip(this.temInfo))
                    {
                        if (PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
                        {
                            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, this.temInfo.Place, BagInfo.EQUIPBAG, _local_2, this.temInfo.Count);
                        }
                        else
                        {
                            SocketManager.Instance.out.sendMoveGoods(BagInfo.EQUIPBAG, this.temInfo.Place, BagInfo.EQUIPBAG, _local_1, this.temInfo.Count);
                        };
                    };
                };
            };
        }

        private function __cellAddPrice(_arg_1:Event):void
        {
            var _local_2:LockBagCell = CellMenu.instance.cell;
            if (_local_2)
            {
                if (ShopManager.Instance.canAddPrice(_local_2.itemInfo.TemplateID))
                {
                    if (PlayerManager.Instance.Self.bagLocked)
                    {
                        BaglockedManager.Instance.show();
                        return;
                    };
                    AddPricePanel.Instance.setInfo(_local_2.itemInfo, false);
                    AddPricePanel.Instance.show();
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.cantAddPrice"));
                };
            };
        }

        private function __cellMove(_arg_1:Event):void
        {
            var _local_2:LockBagCell = CellMenu.instance.cell;
            if (_local_2)
            {
                _local_2.dragStart();
            };
        }

        protected function __cellOpen(_arg_1:Event):void
        {
            var _local_3:Number;
            var _local_4:Date;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:BaseAlerFrame;
            var _local_2:LockBagCell = (CellMenu.instance.cell as LockBagCell);
            this._currentCell = _local_2;
            if (((!(_local_2 == null)) && (!(_local_2.itemInfo == null))))
            {
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
                _local_3 = ((PlayerManager.Instance.Self.Sex) ? 1 : 2);
                if (((!(_local_2.info.NeedSex == 0)) && (!(_local_3 == _local_2.info.NeedSex))))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.sexErr"));
                    return;
                };
                if (PlayerManager.Instance.Self.Grade >= _local_2.info.NeedLevel)
                {
                    if (EquipType.isTimeBox(_local_2.info))
                    {
                        _local_4 = DateUtils.getDateByStr(InventoryItemInfo(_local_2.info).BeginDate);
                        _local_5 = int(((int(_local_2.info.Property3) * 60) - ((TimeManager.Instance.Now().time - _local_4.getTime()) / 1000)));
                        if (_local_5 <= 0)
                        {
                            SocketManager.Instance.out.sendItemOpenUp(_local_2.itemInfo.BagType, _local_2.itemInfo.Place);
                        }
                        else
                        {
                            _local_6 = int((_local_5 / 3600));
                            _local_7 = int(((_local_5 % 3600) / 60));
                            _local_7 = ((_local_7 > 0) ? _local_7 : 1);
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.userGuild.boxTip", _local_6, _local_7));
                        };
                    }
                    else
                    {
                        if (EquipType.isSpecilPackage(_local_2.info))
                        {
                            if (PlayerManager.Instance.Self.DDTMoney >= Number(_local_2.info.Property3))
                            {
                                _local_8 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBag", _local_2.info.Property3, _local_2.info.Name), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                                _local_8.addEventListener(FrameEvent.RESPONSE, this.__GiftBagframeClose);
                            }
                            else
                            {
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.AskGiftBagII", _local_2.info.Property3));
                            };
                        }
                        else
                        {
                            SocketManager.Instance.out.sendItemOpenUp(_local_2.itemInfo.BagType, _local_2.itemInfo.Place);
                        };
                    };
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.level"));
                };
            };
        }

        private function __GiftBagframeClose(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    if (((this._currentCell) && (this._currentCell.itemInfo)))
                    {
                        SocketManager.Instance.out.sendItemOpenUp(this._currentCell.itemInfo.BagType, this._currentCell["place"]);
                    };
                    break;
            };
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__GiftBagframeClose);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        private function __cellUse(_arg_1:Event):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            _arg_1.stopImmediatePropagation();
            var _local_2:LockBagCell = (CellMenu.instance.cell as LockBagCell);
            if (((!(_local_2)) || (_local_2.info == null)))
            {
                return;
            };
            if (_local_2.info.TemplateID == EquipType.VITALITY_WATER)
            {
                this.useCard(_local_2.itemInfo);
                return;
            };
            if (_local_2.info.TemplateID == EquipType.REWORK_NAME)
            {
                this.startReworkName(_local_2.bagType, _local_2.itemInfo.Place);
                return;
            };
            if ((((_local_2.info.CategoryID == 11) && (_local_2.info.Property1 == "5")) && (!(_local_2.info.Property2 == "0"))))
            {
                this.showChatBugleInputFrame(_local_2.info.TemplateID);
                return;
            };
            if (((_local_2.info.CategoryID == 11) && (_local_2.info.Property1 == "34")))
            {
                this.usePetBless(_local_2.itemInfo);
                return;
            };
            if (_local_2.info.TemplateID == EquipType.CONSORTIA_REWORK_NAME)
            {
                if (PlayerManager.Instance.Self.ConsortiaID == 0)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert1"));
                    return;
                };
                if (PlayerManager.Instance.Self.NickName != PlayerManager.Instance.Self.consortiaInfo.ChairmanName)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert2"));
                    return;
                };
                this.startupConsortiaReworkName(_local_2.bagType, _local_2.itemInfo.Place);
                return;
            };
            if (_local_2.info.TemplateID == EquipType.CHANGE_SEX)
            {
                this.startupChangeSex(_local_2.bagType, _local_2.itemInfo.Place);
                return;
            };
            if (((_local_2.info.CategoryID == 11) && (int(_local_2.info.Property1) == 37)))
            {
                if (PlayerManager.Instance.Self.Bag.getItemAt(6))
                {
                    if (PlayerManager.Instance.Self.Bag.getItemAt(6).StrengthenLevel >= 10)
                    {
                        SocketManager.Instance.out.sendUseChangeColorShell(_local_2.bagType, _local_2.place);
                        return;
                    };
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bagAndInfo.bag.UnableUseColorShell"));
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.bagAndInfo.ColorShell.NoWeapon"));
                    return;
                };
            };
            if (_local_2.info.TemplateID == EquipType.COLORCARD)
            {
                if ((!(this._changeColorController)))
                {
                    this._changeColorController = new ChangeColorController();
                };
                this._changeColorController.changeColorModel.place = _local_2.itemInfo.Place;
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__changeColorProgress);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__changeColorComplete);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CHANGECOLOR);
            }
            else
            {
                if (_local_2.info.TemplateID != EquipType.TRANSFER_PROP)
                {
                    if (_local_2.info.CategoryID == EquipType.COMPOSE_SKILL)
                    {
                        SocketManager.Instance.out.sendFormula(_local_2.itemInfo.Place);
                    }
                    else
                    {
                        if (((_local_2.info.CategoryID == 11) && (int(_local_2.info.Property1) == 100)))
                        {
                            this.useProp(_local_2.itemInfo);
                        }
                        else
                        {
                            this.useCard(_local_2.itemInfo);
                            if (_local_2.itemInfo.TemplateID == EquipType.VIPCARD_TEST)
                            {
                                VipController.instance.show();
                            };
                        };
                    };
                };
            };
        }

        private function __cellOpenAll(_arg_1:Event):void
        {
            var _local_3:OpenAllFrame;
            var _local_2:LockBagCell = (CellMenu.instance.cell as LockBagCell);
            this._currentCell = _local_2;
            if (((!(_local_2 == null)) && (!(_local_2.itemInfo == null))))
            {
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
            };
            if (PlayerManager.Instance.Self.Grade >= _local_2.info.NeedLevel)
            {
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("ddt.corei.OpenAllFrame");
                _local_3.ItemInfo = _local_2.itemInfo;
                LayerManager.Instance.addToLayer(_local_3, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.level"));
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__changeColorProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__changeColorComplete);
        }

        private function __changeColorProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.CHANGECOLOR)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __changeColorComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.CHANGECOLOR)
            {
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__changeColorProgress);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__changeColorComplete);
                UIModuleSmallLoading.Instance.hide();
                this._changeColorController.show();
            };
        }

        private function useCard(_arg_1:InventoryItemInfo):void
        {
            if (_arg_1.CanUse)
            {
                if (((this._self.Grade < 3) && ((_arg_1.TemplateID == EquipType.VIPCARD) || (_arg_1.TemplateID == EquipType.VIPCARD_TEST))))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip", 3));
                    return;
                };
                SocketManager.Instance.out.sendUseCard(_arg_1.BagType, _arg_1.Place, [_arg_1.TemplateID], _arg_1.PayType);
            };
        }

        private function useProp(_arg_1:InventoryItemInfo):void
        {
            if ((!(_arg_1)))
            {
                return;
            };
            SocketManager.Instance.out.sendUseProp(_arg_1.BagType, _arg_1.Place, [_arg_1.TemplateID], _arg_1.PayType);
        }

        public function setCellInfo(_arg_1:int, _arg_2:InventoryItemInfo):void
        {
            this._currentList.setCellInfo(_arg_1, _arg_2);
        }

        public function setPlace(_arg_1:int):Point
        {
            if (_arg_1 < 79)
            {
                (this._PageBtnGroup.selectIndex == 0);
                this._equiplist.visible = true;
                this._equiplist1.visible = false;
                this._equiplist2.visible = false;
                this._currentPage = 1;
                return (this._equiplist.getCellPosByPlace(_arg_1));
            };
            if (((79 <= _arg_1) && (_arg_1 < 127)))
            {
                (this._PageBtnGroup.selectIndex == 1);
                this._equiplist.visible = false;
                this._equiplist1.visible = true;
                this._equiplist2.visible = false;
                this._currentPage = 2;
                return (this._equiplist.getCellPosByPlace((_arg_1 - 48)));
            };
            if (((127 <= _arg_1) && (_arg_1 < 175)))
            {
                (this._PageBtnGroup.selectIndex == 2);
                this._equiplist.visible = false;
                this._equiplist1.visible = false;
                this._equiplist2.visible = true;
                this._currentPage = 3;
                return (this._equiplist.getCellPosByPlace((_arg_1 - 96)));
            };
            return (null);
        }

        public function dispose():void
        {
            this.removeEvents();
            this.resetMouse();
            this._changeColorController = null;
            if (this._bagLockControl)
            {
                this._bagLockControl.close();
            };
            this._bagLockControl = null;
            this._info = null;
            this.infos = null;
            if (this._sellBtn)
            {
                this._sellBtn.removeEventListener(MouseEvent.CLICK, this.__sellClick);
            };
            if (this._sellBtn)
            {
                this._sellBtn.removeEventListener(SellGoodsBtn.StopSell, this.__stopSell);
            };
            if (this._breakBtn)
            {
                this._breakBtn.removeEventListener(MouseEvent.CLICK, this.__breakClick);
            };
            if (this._frame)
            {
                this._frame.removeEventListener(FrameEvent.RESPONSE, this.__frameClose);
                this._frame.dispose();
                this._frame = null;
                SocketManager.Instance.out.sendClearStoreBag();
            };
            if (this._goodsNumInfoBg)
            {
                ObjectUtils.disposeObject(this._goodsNumInfoBg);
            };
            this._goodsNumInfoBg = null;
            if (this._goodsNumInfoText)
            {
                ObjectUtils.disposeObject(this._goodsNumInfoText);
            };
            this._goodsNumInfoText = null;
            if (this._goodsNumTotalText)
            {
                ObjectUtils.disposeObject(this._goodsNumTotalText);
            };
            this._goodsNumTotalText = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._bg1)
            {
                ObjectUtils.disposeObject(this._bg1);
            };
            this._bg1 = null;
            if (this._sortBagBtn)
            {
                ObjectUtils.disposeObject(this._sortBagBtn);
            };
            this._sortBagBtn = null;
            if (this._settingLockBtn)
            {
                ObjectUtils.disposeObject(this._settingLockBtn);
            };
            this._settingLockBtn = null;
            if (this._settedLockBtn)
            {
                ObjectUtils.disposeObject(this._settedLockBtn);
            };
            this._settedLockBtn = null;
            if (this._breakBtn)
            {
                ObjectUtils.disposeObject(this._breakBtn);
            };
            this._breakBtn = null;
            this._currentList = null;
            if (this._sellBtn)
            {
                ObjectUtils.disposeObject(this._sellBtn);
            };
            this._sellBtn = null;
            this._equiplist = null;
            this._equiplist1 = null;
            this._equiplist2 = null;
            if (this._bgShape)
            {
                ObjectUtils.disposeObject(this._bgShape);
            };
            this._bgShape = null;
            if (this._continueBtn)
            {
                ObjectUtils.disposeObject(this._continueBtn);
            };
            this._continueBtn = null;
            if (this._chatBugleInputFrame)
            {
                ObjectUtils.disposeObject(this._chatBugleInputFrame);
            };
            this._chatBugleInputFrame = null;
            if (this._bagList)
            {
                ObjectUtils.disposeObject(this._bagList);
            };
            this._bagList = null;
            if (this._PageBtnGroup)
            {
                ObjectUtils.disposeObject(this._PageBtnGroup);
            };
            this._PageBtnGroup = null;
            if (this._onePageBtn)
            {
                ObjectUtils.disposeObject(this._onePageBtn);
            };
            this._onePageBtn = null;
            if (this._TwoPageBtn)
            {
                ObjectUtils.disposeObject(this._TwoPageBtn);
            };
            this._TwoPageBtn = null;
            if (this._ThreePageBtn)
            {
                ObjectUtils.disposeObject(this._ThreePageBtn);
            };
            this._ThreePageBtn = null;
            if (this._ClassBtnGroup)
            {
                ObjectUtils.disposeObject(this._ClassBtnGroup);
            };
            this._ClassBtnGroup = null;
            if (this._allClassBtn)
            {
                this._allClassBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
                ObjectUtils.disposeObject(this._allClassBtn);
                this._allClassBtn = null;
            };
            if (this._equipClassBtn)
            {
                this._equipClassBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
                ObjectUtils.disposeObject(this._equipClassBtn);
                this._equipClassBtn = null;
            };
            if (this._fashionClassBtn)
            {
                this._fashionClassBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
                ObjectUtils.disposeObject(this._fashionClassBtn);
                this._fashionClassBtn = null;
            };
            if (this._propClassBtn)
            {
                this._propClassBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
                ObjectUtils.disposeObject(this._propClassBtn);
                this._propClassBtn = null;
            };
            if (this._questClassBtn)
            {
                this._questClassBtn.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
                ObjectUtils.disposeObject(this._questClassBtn);
                this._questClassBtn = null;
            };
            if (this._reworknameView)
            {
                this.shutdownReworkName();
            };
            if (this._consortaiReworkName)
            {
                this.shutdownConsortiaReworkName();
            };
            if (CellMenu.instance.showed)
            {
                CellMenu.instance.hide();
            };
            if (this._moneyView)
            {
                ObjectUtils.disposeObject(this._moneyView);
                this._moneyView = null;
            };
            if (this._ddtmoneyView)
            {
                ObjectUtils.disposeObject(this._ddtmoneyView);
                this._ddtmoneyView = null;
            };
            if (this._goldView)
            {
                ObjectUtils.disposeObject(this._goldView);
                this._goldView = null;
            };
            AddPricePanel.Instance.close();
            PlayerManager.Instance.Self.bagVibleType = 0;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function setBagCountShow(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:GlowFilter;
            var _local_4:uint;
            switch (_arg_1)
            {
                case BagInfo.EQUIPBAG:
                    _local_2 = PlayerManager.Instance.Self.getBag(_arg_1).itemBgNumber(this._equiplist._startIndex, this._equiplist._stopIndex);
                    if (_local_2 >= 49)
                    {
                        _local_4 = 0xFF0000;
                        _local_3 = new GlowFilter(0xFFFFFF, 0.5, 3, 3, 10);
                    }
                    else
                    {
                        _local_4 = 1310468;
                        _local_3 = new GlowFilter(876032, 0.5, 3, 3, 10);
                    };
                    break;
                case BagInfo.PROPBAG:
                    _local_2 = PlayerManager.Instance.Self.getBag(_arg_1).itemBgNumber(0, BagInfo.MAXPROPCOUNT);
                    if (_local_2 >= (BagInfo.MAXPROPCOUNT + 1))
                    {
                        _local_4 = 0xFF0000;
                        _local_3 = new GlowFilter(0xFFFFFF, 0.5, 3, 3, 10);
                    }
                    else
                    {
                        _local_4 = 1310468;
                        _local_3 = new GlowFilter(876032, 0.5, 3, 3, 10);
                    };
                    break;
            };
            this._goodsNumInfoText.textColor = _local_4;
            this._goodsNumInfoText.text = _local_2.toString();
            this.setBagType(_arg_1);
        }

        public function get info():SelfInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:SelfInfo):void
        {
            if (this._info)
            {
                this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
                this._info.getBag(BagInfo.EQUIPBAG).removeEventListener(BagEvent.UPDATE, this.__onBagUpdateEQUIPBAG);
                PlayerManager.Instance.Self.removeEventListener(BagEvent.CLEAR, this.__clearHandler);
                PlayerManager.Instance.Self.removeEventListener(BagEvent.AFTERDEL, this.__clearHandler);
                PlayerManager.Instance.Self.removeEventListener(BagEvent.CHANGEPSW, this.__clearHandler);
                PlayerManager.Instance.Self.removeEventListener(BagEvent.SHOW_BEAD, this.__showBead);
            };
            this._info = _arg_1;
            if (this._info)
            {
                this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
                this._info.getBag(BagInfo.EQUIPBAG).addEventListener(BagEvent.UPDATE, this.__onBagUpdateEQUIPBAG);
                PlayerManager.Instance.Self.addEventListener(BagEvent.CLEAR, this.__clearHandler);
                PlayerManager.Instance.Self.addEventListener(BagEvent.AFTERDEL, this.__clearHandler);
                PlayerManager.Instance.Self.addEventListener(BagEvent.CHANGEPSW, this.__clearHandler);
                PlayerManager.Instance.Self.addEventListener(BagEvent.SHOW_BEAD, this.__showBead);
            };
            this.updateView();
            if (this._bagType == EQUIP)
            {
                this.initEquipBagPage();
            };
        }

        private function startReworkName(_arg_1:int, _arg_2:int):void
        {
            this._reworknameView = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ReworkName.ReworkNameFrame");
            LayerManager.Instance.addToLayer(this._reworknameView, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this._reworknameView.initialize(_arg_1, _arg_2);
            this._reworknameView.addEventListener(Event.COMPLETE, this.__onRenameComplete);
        }

        private function shutdownReworkName():void
        {
            this._reworknameView.removeEventListener(Event.COMPLETE, this.__onRenameComplete);
            ObjectUtils.disposeObject(this._reworknameView);
            this._reworknameView = null;
        }

        private function __onRenameComplete(_arg_1:Event):void
        {
            this.shutdownReworkName();
        }

        private function startupConsortiaReworkName(_arg_1:int, _arg_2:int):void
        {
            this._consortaiReworkName = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ReworkName.ReworkNameConsortia");
            LayerManager.Instance.addToLayer(this._consortaiReworkName, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this._consortaiReworkName.initialize(_arg_1, _arg_2);
            this._consortaiReworkName.addEventListener(Event.COMPLETE, this.__onConsortiaRenameComplete);
        }

        private function shutdownConsortiaReworkName():void
        {
            this._consortaiReworkName.removeEventListener(Event.COMPLETE, this.__onConsortiaRenameComplete);
            ObjectUtils.disposeObject(this._consortaiReworkName);
            this._consortaiReworkName = null;
        }

        private function showChatBugleInputFrame(_arg_1:int):void
        {
            if (this._chatBugleInputFrame == null)
            {
                this._chatBugleInputFrame = ComponentFactory.Instance.creat("chat.BugleInputFrame");
            };
            this._chatBugleInputFrame.templateID = _arg_1;
            LayerManager.Instance.addToLayer(this._chatBugleInputFrame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
        }

        private function __onConsortiaRenameComplete(_arg_1:Event):void
        {
            this.shutdownConsortiaReworkName();
        }

        public function hide():void
        {
            if (this._reworknameView)
            {
                this.shutdownReworkName();
            };
            if (this._consortaiReworkName)
            {
                this.shutdownConsortiaReworkName();
            };
        }

        private function startupChangeSex(_arg_1:int, _arg_2:int):void
        {
            var _local_3:ChangeSexAlertFrame = ComponentFactory.Instance.creat("bagAndInfo.bag.changeSexAlert");
            _local_3.bagType = _arg_1;
            _local_3.place = _arg_2;
            _local_3.info = this.getAlertInfo("tank.view.bagII.changeSexAlert", true);
            _local_3.addEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onAlertSizeChanged);
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            LayerManager.Instance.addToLayer(_local_3, LayerManager.GAME_DYNAMIC_LAYER, _local_3.info.frameCenter, LayerManager.BLCAK_BLOCKGOUND);
            StageReferance.stage.focus = _local_3;
        }

        private function getAlertInfo(_arg_1:String, _arg_2:Boolean=false):AlertInfo
        {
            var _local_3:AlertInfo = new AlertInfo();
            _local_3.autoDispose = true;
            _local_3.showSubmit = true;
            _local_3.showCancel = _arg_2;
            _local_3.enterEnable = true;
            _local_3.escEnable = true;
            _local_3.moveEnable = false;
            _local_3.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _local_3.data = LanguageMgr.GetTranslation(_arg_1);
            return (_local_3);
        }

        private function __onAlertSizeChanged(_arg_1:ComponentEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            if (_local_2.info.frameCenter)
            {
                _local_2.x = ((StageReferance.stageWidth - _local_2.width) / 2);
                _local_2.y = ((StageReferance.stageHeight - _local_2.height) / 2);
            };
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:ChangeSexAlertFrame = ChangeSexAlertFrame(_arg_1.currentTarget);
            _local_2.removeEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onAlertSizeChanged);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    SocketManager.Instance.out.sendChangeSex(_local_2.bagType, _local_2.place);
                    break;
            };
            _local_2.dispose();
            _local_2 = null;
        }

        private function __changeSexHandler(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_3:SimpleAlert;
            SocketManager.Instance.socket.close();
            var _local_2:Boolean = _arg_1.pkg.readBoolean();
            if (_local_2)
            {
                _local_3 = ComponentFactory.Instance.creat("sellGoodsAlert");
                _local_3.info = this.getAlertInfo("tank.view.bagII.changeSexAlert.success", false);
                _local_3.addEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onAlertSizeChanged);
                _local_3.addEventListener(FrameEvent.RESPONSE, this.__onSuccessAlertResponse);
                LayerManager.Instance.addToLayer(_local_3, LayerManager.GAME_DYNAMIC_LAYER, _local_3.info.frameCenter, LayerManager.BLCAK_BLOCKGOUND);
                StageReferance.stage.focus = _local_3;
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.changeSexAlert.failed"));
            };
        }

        private function __onSuccessAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            ExternalInterface.call("WindowReturn");
        }

        public function set isScreenTexp(_arg_1:Boolean):void
        {
            this._isScreenTexp = _arg_1;
        }

        public function get isScreenTexp():Boolean
        {
            return (this._isScreenTexp);
        }

        public function get currentPage():int
        {
            return (this._currentPage);
        }

        public function set GoodList(_arg_1:BagInfo):void
        {
        }

        public function set currentPage(_arg_1:int):void
        {
            this._currentPage = _arg_1;
            this._equipBag = this.getEquipList(this._info.Bag, PlayerManager.Instance.Self.bagVibleType);
            switch (this._currentPage)
            {
                case 1:
                    this._equiplist.setData(this._equipBag);
                    return;
                case 2:
                    this._equiplist1.setData(this._equipBag);
                    return;
                case 3:
                    this._equiplist2.setData(this._equipBag);
                    return;
            };
        }


    }
}//package bagAndInfo.bag

