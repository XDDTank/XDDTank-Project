// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.chooseMap.DungeonChooseMapView

package room.view.chooseMap
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.loader.DisplayLoader;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import __AS3__.vec.Vector;
    import ddt.view.ShineSelectButton;
    import ddt.command.StripTip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import flash.events.Event;
    import ddt.manager.PlayerManager;
    import room.RoomManager;
    import room.model.RoomInfo;
    import flash.events.MouseEvent;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.MapManager;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.LayerManager;
    import ddt.data.map.DungeonInfo;
    import ddt.manager.PathManager;
    import ddt.manager.MessageTipManager;
    import ddt.utils.FilterWordManager;
    import __AS3__.vec.*;

    public class DungeonChooseMapView extends Sprite implements Disposeable 
    {

        public static const DUNGEON_NO:int = 13;
        public static const DEFAULT_MAP:int = -1;
        public static const NORMAL:int = 0;
        public static const SPECIAL:int = 1;

        private var _titleLoader:DisplayLoader;
        private var _preViewLoader:DisplayLoader;
        private var _modebg:Bitmap;
        private var _bigBg:MutipleImage;
        private var _roomMode:Bitmap;
        private var _modeline:Bitmap;
        private var _roomName:FilterFrameText;
        private var _roomPass:FilterFrameText;
        private var _nameInput:TextInput;
        private var _passInput:TextInput;
        private var _checkBox:SelectedCheckButton;
        private var _modeDescriptionTxt:FilterFrameText;
        private var _fbMode:FilterFrameText;
        private var _dungeonList:SimpleTileList;
        private var _maps:Array;
        private var _dungeonListContainer:ScrollPanel;
        private var _dungeonPreView:Sprite;
        private var _dungeonTitle:Sprite;
        private var _dungeonDescriptionTxt:TextArea;
        private var _btnGroup:SelectedButtonGroup;
        private var _mapTypBtn_n:SelectedTextButton;
        private var _mapTypBtn_s:SelectedTextButton;
        private var _selectedDungeonType:int;
        private var _btns:Vector.<ShineSelectButton>;
        private var _group:SelectedButtonGroup;
        private var _easyBtn:ShineSelectButton;
        private var _normalBtn:ShineSelectButton;
        private var _hardBtn:ShineSelectButton;
        private var _heroBtn:ShineSelectButton;
        private var _timeTxt:FilterFrameText;
        private var _bossBtn:SelectedCheckButton;
        private var _bossIMG:Bitmap;
        private var _bossBtnStrip:StripTip;
        private var _grayFilters:Array;
        private var _currentSelectedItem:DungeonMapItem;
        private var _line:ScaleBitmapImage;
        private var _rect1:Rectangle;
        private var _rect2:Rectangle;
        private var _rect3:Rectangle;
        private var _dungeonInfoList:Dictionary;
        private var _selectedLevel:int = -1;

        public function DungeonChooseMapView()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var _local_2:DungeonMapItem;
            this._modebg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.dungeon.ChooseMap.modeBg");
            addChild(this._modebg);
            this._roomMode = ComponentFactory.Instance.creatBitmap("asset.ddtroom.setView.modeWord");
            addChild(this._roomMode);
            PositionUtils.setPos(this._roomMode, "asset.ddtroom.dungeon.roomModePos");
            this._modeline = ComponentFactory.Instance.creatBitmap("asset.ddtroom.selectedMapLine");
            addChild(this._modeline);
            this._roomName = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.name");
            addChild(this._roomName);
            PositionUtils.setPos(this._roomName, "asset.ddtroom.dungeon.roomNamePos");
            this._roomName.text = LanguageMgr.GetTranslation("ddt.matchRoom.setView.roomname");
            this._roomPass = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.password");
            addChild(this._roomPass);
            PositionUtils.setPos(this._roomPass, "asset.ddtroom.dungeon.roomPassPos");
            this._roomPass.text = LanguageMgr.GetTranslation("ddt.matchRoom.setView.password");
            this._nameInput = ComponentFactory.Instance.creatComponentByStylename("asset.ddtRoom.dungeon.ChooseMap.nameInput");
            addChild(this._nameInput);
            this._nameInput.textField.multiline = false;
            this._nameInput.textField.wordWrap = false;
            this._passInput = ComponentFactory.Instance.creatComponentByStylename("asset.ddtRoom.dungeon.ChooseMap.passInput");
            addChild(this._passInput);
            this._passInput.textField.restrict = "0-9A-Za-z";
            this._checkBox = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.selectBtn");
            addChild(this._checkBox);
            PositionUtils.setPos(this._checkBox, "asset.ddtroom.dungeon.chockBoxPos");
            this._fbMode = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.fbmode");
            addChild(this._fbMode);
            this._fbMode.text = LanguageMgr.GetTranslation("ddt.dungeonroom.choseMap.fbmode");
            this._modeDescriptionTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.descript");
            addChild(this._modeDescriptionTxt);
            this._modeDescriptionTxt.text = LanguageMgr.GetTranslation("room.view.chooseMap.DungeonChooseMapView.dungeonModeDescription");
            this._bigBg = ComponentFactory.Instance.creatComponentByStylename("asset.selectedDungeon.BigBg");
            addChild(this._bigBg);
            this._line = ComponentFactory.Instance.creatComponentByStylename("asset.selectedDungeon.line");
            addChild(this._line);
            this._dungeonList = ComponentFactory.Instance.creat("asset.room.view.chooseMap.mapList", [4]);
            this._maps = [];
            var _local_1:int;
            while (_local_1 < DUNGEON_NO)
            {
                _local_2 = new DungeonMapItem();
                this._dungeonList.addChild(_local_2);
                _local_2.addEventListener(Event.SELECT, this.__onItemSelect);
                this._maps.push(_local_2);
                _local_1++;
            };
            this._dungeonListContainer = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeonMapSetScrollPanel");
            this._dungeonListContainer.vScrollProxy = ScrollPanel.ON;
            addChild(this._dungeonListContainer);
            this._dungeonListContainer.setView(this._dungeonList);
            this._dungeonDescriptionTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.descriptArea");
            addChild(this._dungeonDescriptionTxt);
            this._dungeonDescriptionTxt.textField.selectable = false;
            this._dungeonTitle = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.chooseDungeonTitle");
            addChild(this._dungeonTitle);
            this._dungeonPreView = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.chooseDungeonPreView");
            addChild(this._dungeonPreView);
            this._mapTypBtn_n = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.FBType1");
            this._mapTypBtn_n.text = LanguageMgr.GetTranslation("ddt.dungeonroom.type.normal");
            this._mapTypBtn_s = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.FBType2");
            this._mapTypBtn_s.text = LanguageMgr.GetTranslation("ddt.dungeonroom.type.spaciel");
            addChild(this._mapTypBtn_n);
            addChild(this._mapTypBtn_s);
            this._btnGroup = new SelectedButtonGroup();
            this._btnGroup.addSelectItem(this._mapTypBtn_n);
            this._btnGroup.addSelectItem(this._mapTypBtn_s);
            this._btnGroup.selectIndex = 0;
            this._btns = new Vector.<ShineSelectButton>();
            this._group = new SelectedButtonGroup();
            this._easyBtn = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.easyButton");
            addChild(this._easyBtn);
            this._btns.push(this._easyBtn);
            this._group.addSelectItem(this._easyBtn);
            this._normalBtn = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.normalButton");
            addChild(this._normalBtn);
            this._btns.push(this._normalBtn);
            this._group.addSelectItem(this._normalBtn);
            this._hardBtn = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.hardButton");
            addChild(this._hardBtn);
            this._btns.push(this._hardBtn);
            this._group.addSelectItem(this._hardBtn);
            this._heroBtn = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.heroButton");
            addChild(this._heroBtn);
            this._btns.push(this._heroBtn);
            this._group.addSelectItem(this._heroBtn);
            this._bossBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.dungeonRoom.bossBtn");
            this._bossIMG = ComponentFactory.Instance.creatBitmap("asset.ddtroom.dungeonChoose.boss");
            this._bossBtn.addChild(this._bossIMG);
            this._bossBtn.tipData = LanguageMgr.GetTranslation("ddt.dungeonRoom.bossBtn.tiptext");
            this._bossBtnStrip = ComponentFactory.Instance.creatCustomObject("ddt.dungeonRoom.bossBtnStrip");
            this._bossBtnStrip.tipData = LanguageMgr.GetTranslation("ddt.dungeonRoom.bossBtn.tiptext");
            PositionUtils.setPos(this._bossBtnStrip, "ddt.dungeonRoom.bossBtnStripPos");
            this._grayFilters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._rect1 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.levelBtnPos1");
            this._rect2 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.levelBtnPos2");
            this._rect3 = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.levelBtnPos3");
            this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("room.special.timeTxt");
            this.updateTimeShow();
            this.updateDescription();
            this.updatePreView();
            this.updateLevelBtn();
            this.updateRoomInfo();
            this.initInfo();
            if ((((PlayerManager.Instance.Self.VIPLevel >= 7) && (PlayerManager.Instance.Self.IsVIP)) && (!(this._btnGroup.selectIndex == 1))))
            {
                this.setBossBtnState(false);
            }
            else
            {
                this.setBossBtnState(false);
            };
        }

        private function updateRoomInfo():void
        {
            this._nameInput.text = RoomManager.Instance.current.Name;
            if (RoomManager.Instance.current.roomPass)
            {
                this._checkBox.selected = true;
                this._passInput.text = RoomManager.Instance.current.roomPass;
            }
            else
            {
                this._checkBox.selected = false;
            };
            this.upadtePassTextBg();
        }

        private function initInfo():void
        {
            var _local_2:DungeonMapItem;
            switch (RoomManager.Instance.current.dungeonType)
            {
                case RoomInfo.DUNGEONTYPE_NO:
                    this._btnGroup.selectIndex = 0;
                    this.updateCommonItem();
                    break;
                case RoomInfo.DUNGEONTYPE_SP:
                    this._btnGroup.selectIndex = 1;
                    this.updateSpecialItem();
                    break;
                default:
                    this.updateCommonItem();
            };
            var _local_1:int = RoomManager.Instance.current.mapId;
            if (((_local_1 > 0) && (!(_local_1 == DEFAULT_MAP))))
            {
                for each (_local_2 in this._maps)
                {
                    if (_local_2.mapId == _local_1)
                    {
                        this._currentSelectedItem = _local_2;
                        this._currentSelectedItem.selected = true;
                    };
                };
                switch (RoomManager.Instance.current.hardLevel)
                {
                    case RoomInfo.EASY:
                        this._group.selectIndex = 0;
                        this._selectedLevel = RoomInfo.EASY;
                        return;
                    case RoomInfo.NORMAL:
                        this._group.selectIndex = 1;
                        this._selectedLevel = RoomInfo.NORMAL;
                        return;
                    case RoomInfo.HARD:
                        this._group.selectIndex = 2;
                        this._selectedLevel = RoomInfo.HARD;
                        return;
                    case RoomInfo.HERO:
                        this._group.selectIndex = 3;
                        this._selectedLevel = RoomInfo.HERO;
                        return;
                };
            };
        }

        private function initEvents():void
        {
            this._btnGroup.addEventListener(Event.CHANGE, this.__changeHandler);
            this._mapTypBtn_n.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._mapTypBtn_s.addEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._easyBtn.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._normalBtn.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._hardBtn.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._heroBtn.addEventListener(MouseEvent.CLICK, this.__btnClick);
            this._bossBtn.addEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            this._checkBox.addEventListener(MouseEvent.CLICK, this.__checkBoxClick);
        }

        private function removeEvents():void
        {
            this._btnGroup.removeEventListener(Event.CHANGE, this.__changeHandler);
            this._mapTypBtn_n.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._mapTypBtn_s.removeEventListener(MouseEvent.CLICK, this.__soundPlay);
            this._easyBtn.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            this._normalBtn.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            this._hardBtn.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            this._heroBtn.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            this._bossBtn.removeEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            this._checkBox.removeEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            if (this._titleLoader != null)
            {
                this._titleLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onTitleComplete);
            };
            if (this._preViewLoader != null)
            {
                this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onPreViewComplete);
            };
        }

        private function __changeHandler(_arg_1:Event):void
        {
            this._selectedDungeonType = (this._btnGroup.selectIndex + 1);
            if (this._btnGroup.selectIndex == 0)
            {
                if (((PlayerManager.Instance.Self.VIPLevel >= 7) && (PlayerManager.Instance.Self.IsVIP)))
                {
                    this.setBossBtnState(true);
                };
                this.updateCommonItem();
            }
            else
            {
                this.setBossBtnState(false);
                this.updateSpecialItem();
            };
            this.updateTimeShow();
            this.updateDescription();
        }

        private function __soundPlay(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function __checkBoxClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.currentTarget)
            {
                case this._checkBox:
                    this.upadtePassTextBg();
                    return;
                case this._bossBtn:
                    this.checkState();
                    return;
            };
        }

        private function updateCommonItem():void
        {
            var _local_2:DungeonMapItem;
            this.reset();
            var _local_1:int;
            while (_local_1 < DUNGEON_NO)
            {
                if (MapManager.getByOrderingDungeonInfo(_local_1))
                {
                    _local_2 = (this._maps[_local_1] as DungeonMapItem);
                    _local_2.mapId = MapManager.getByOrderingDungeonInfo(_local_1).ID;
                };
                _local_1++;
            };
        }

        private function updateSpecialItem():void
        {
            var _local_2:DungeonMapItem;
            this.reset();
            var _local_1:int = 1;
            while (_local_1 < DUNGEON_NO)
            {
                if (MapManager.getByOrderingSpecialDungeonInfo((_local_1 - 1)))
                {
                    _local_2 = (this._maps[(_local_1 - 1)] as DungeonMapItem);
                    _local_2.mapId = MapManager.getByOrderingSpecialDungeonInfo((_local_1 - 1)).ID;
                };
                _local_1++;
            };
        }

        private function reset():void
        {
            var _local_3:DungeonMapItem;
            this.InitChooseMapState();
            var _local_1:int = 1;
            while (_local_1 < this._maps.length)
            {
                _local_3 = (this._maps[(_local_1 - 1)] as DungeonMapItem);
                _local_3.selected = false;
                _local_3.stopShine();
                _local_3.mapId = DEFAULT_MAP;
                _local_1++;
            };
            var _local_2:int;
            while (_local_2 < this._btns.length)
            {
                this._btns[_local_2].selected = false;
                this._btns[_local_2].stopShine();
                _local_2++;
            };
        }

        private function InitChooseMapState():void
        {
            this._currentSelectedItem = null;
            this._normalBtn.visible = (this._hardBtn.visible = (this._heroBtn.visible = true));
            this._normalBtn.enable = (this._hardBtn.enable = (this._heroBtn.enable = false));
            this.adaptButtons(0);
            ObjectUtils.disposeAllChildren(this._dungeonPreView);
            if (this._preViewLoader)
            {
                this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onPreViewComplete);
                this._preViewLoader = null;
            };
            this._preViewLoader = LoadResourceManager.instance.createLoader("image/map/10000/samll_map.png", BaseLoader.BITMAP_LOADER);
            this._preViewLoader.addEventListener(LoaderEvent.COMPLETE, this.__onPreViewComplete);
            LoadResourceManager.instance.startLoad(this._preViewLoader);
            if (this._titleLoader != null)
            {
                this._titleLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onTitleComplete);
            };
            this._titleLoader = LoadResourceManager.instance.createLoader("image/map/10000/icon.png", BaseLoader.BITMAP_LOADER);
            this._titleLoader.addEventListener(LoaderEvent.COMPLETE, this.__onTitleComplete);
            LoadResourceManager.instance.startLoad(this._titleLoader);
            this._dungeonDescriptionTxt.text = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
        }

        private function upadtePassTextBg():void
        {
            if (this._checkBox.selected)
            {
                this._passInput.mouseChildren = true;
                this._passInput.mouseEnabled = true;
                this._passInput.setFocus();
            }
            else
            {
                this._passInput.mouseChildren = false;
                this._passInput.mouseEnabled = false;
                this._passInput.text = "";
            };
        }

        public function get roomName():String
        {
            return (this._nameInput.text);
        }

        public function get roomPass():String
        {
            return (this._passInput.text);
        }

        public function get selectedDungeonType():int
        {
            return (this._selectedDungeonType);
        }

        public function get select():Boolean
        {
            return (this._bossBtn.selected);
        }

        private function __onItemSelect(_arg_1:Event):void
        {
            var _local_3:ShineSelectButton;
            this._bossBtn.selected = false;
            var _local_2:DungeonMapItem = (_arg_1.target as DungeonMapItem);
            if (((this._currentSelectedItem) && (!(this._currentSelectedItem == _local_2))))
            {
                this._currentSelectedItem.selected = false;
            };
            this._currentSelectedItem = (_arg_1.target as DungeonMapItem);
            this.stopShineMap();
            this.stopShineLevelBtn();
            for each (_local_3 in this._btns)
            {
                _local_3.selected = false;
            };
            this._selectedLevel = -1;
            this.updateTimeShow();
            this.updateDescription();
            this.updatePreView();
            this.updateLevelBtn();
        }

        private function showAlert():void
        {
            var _local_1:Frame = ComponentFactory.Instance.creat("room.FifthPreview");
            _local_1.addEventListener(FrameEvent.RESPONSE, this.__onPreResponse);
            _local_1.escEnable = true;
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_TOP_LAYER, false, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __onPreResponse(_arg_1:FrameEvent):void
        {
            var _local_2:Frame = (_arg_1.target as Frame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onPreResponse);
            _local_2.dispose();
        }

        private function __btnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.stopShineLevelBtn();
            switch (_arg_1.currentTarget)
            {
                case this._easyBtn:
                    this._selectedLevel = DungeonInfo.EASY;
                    return;
                case this._normalBtn:
                    this._selectedLevel = DungeonInfo.NORMAL;
                    return;
                case this._hardBtn:
                    this._selectedLevel = DungeonInfo.HARD;
                    return;
                case this._heroBtn:
                    this._selectedLevel = DungeonInfo.HERO;
                    return;
            };
        }

        private function updateTimeShow():void
        {
            if (this._btnGroup.selectIndex == NORMAL)
            {
                this._timeTxt.visible = false;
            }
            else
            {
                if (((this._btnGroup.selectIndex == SPECIAL) && (this._currentSelectedItem)))
                {
                    this._timeTxt.visible = true;
                    this._timeTxt.text = LanguageMgr.GetTranslation("ddt.dungeonroom.type.spaciel.timeTxt", "1", "3");
                };
            };
        }

        private function updateDescription():void
        {
            if (this._titleLoader != null)
            {
                this._titleLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onTitleComplete);
            };
            this._titleLoader = LoadResourceManager.instance.createLoader(this.solveTitlePath(), BaseLoader.BITMAP_LOADER);
            this._titleLoader.addEventListener(LoaderEvent.COMPLETE, this.__onTitleComplete);
            LoadResourceManager.instance.startLoad(this._titleLoader);
            this._dungeonDescriptionTxt.upScrollArea();
            if (this._currentSelectedItem)
            {
                this._dungeonDescriptionTxt.text = MapManager.getDungeonInfo(this._currentSelectedItem.mapId).Description;
            }
            else
            {
                this._dungeonDescriptionTxt.text = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
            };
            if (this._btnGroup.selectIndex == 0)
            {
                this._modeDescriptionTxt.text = LanguageMgr.GetTranslation("room.view.chooseMap.DungeonChooseMapView.dungeonModeDescription");
            }
            else
            {
                if (this._btnGroup.selectIndex == 1)
                {
                    this._modeDescriptionTxt.text = LanguageMgr.GetTranslation("room.view.chooseMap.DungeonChooseMapView.dungeonModeDescription2");
                };
            };
        }

        private function solveTitlePath():String
        {
            var _local_1:String = (PathManager.SITE_MAIN + "image/map/");
            if (this._currentSelectedItem)
            {
                _local_1 = (_local_1 + (this._currentSelectedItem.mapId.toString() + "/icon.png"));
            }
            else
            {
                _local_1 = (_local_1 + "10000/icon.png");
            };
            return (_local_1);
        }

        private function updatePreView():void
        {
            ObjectUtils.disposeAllChildren(this._dungeonPreView);
            if (this._preViewLoader)
            {
                this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onPreViewComplete);
                this._preViewLoader = null;
            };
            this._preViewLoader = LoadResourceManager.instance.createLoader(this.solvePreViewPath(), BaseLoader.BITMAP_LOADER);
            this._preViewLoader.addEventListener(LoaderEvent.COMPLETE, this.__onPreViewComplete);
            LoadResourceManager.instance.startLoad(this._preViewLoader);
        }

        private function solvePreViewPath():String
        {
            var _local_1:String = (PathManager.SITE_MAIN + "image/map/");
            if (this._currentSelectedItem)
            {
                _local_1 = (_local_1 + (this._currentSelectedItem.mapId.toString() + "/samll_map.png"));
            }
            else
            {
                _local_1 = (_local_1 + "10000/samll_map.png");
            };
            return (_local_1);
        }

        private function setBossBtnState(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._bossBtnStrip.visible = false;
                this._bossBtn.mouseEnabled = (this._bossBtn.buttonMode = true);
                this._bossBtn.filters = null;
            }
            else
            {
                this._bossBtnStrip.visible = true;
                this._bossBtn.mouseEnabled = (this._bossBtn.buttonMode = false);
                this._bossBtn.filters = this._grayFilters;
            };
            this._bossBtn.selected = false;
        }

        private function updateLevelBtn():void
        {
            this._easyBtn.visible = (this._normalBtn.visible = (this._hardBtn.visible = (this._heroBtn.visible = true)));
            this._easyBtn.enable = (this._normalBtn.enable = (this._hardBtn.enable = (this._heroBtn.enable = false)));
            if (((this._currentSelectedItem) && (MapManager.getDungeonInfo(this._currentSelectedItem.mapId).isOpen)))
            {
                this.adaptButtons(this._currentSelectedItem.mapId);
                this._easyBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId, 0);
                this._normalBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId, 1);
                this._hardBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId, 2);
                this._heroBtn.enable = PlayerManager.Instance.Self.getPveMapPermission(this._currentSelectedItem.mapId, 3);
            }
            else
            {
                this.adaptButtons(0);
            };
        }

        private function adaptButtons(_arg_1:int):void
        {
            var _local_2:DungeonInfo = MapManager.getDungeonInfo(_arg_1);
            if ((!(_local_2)))
            {
                this._easyBtn.visible = false;
                this._normalBtn.x = this._rect3.x;
                this._hardBtn.x = this._rect3.y;
                this._heroBtn.x = this._rect3.width;
                this._normalBtn.y = (this._hardBtn.y = (this._heroBtn.y = (this._rect3.y + 148)));
                return;
            };
            this._easyBtn.visible = (!(_local_2.SimpleTemplateIds == ""));
            this._normalBtn.visible = (!(_local_2.NormalTemplateIds == ""));
            this._hardBtn.visible = (!(_local_2.HardTemplateIds == ""));
            this._heroBtn.visible = (!(_local_2.TerrorTemplateIds == ""));
            var _local_3:Vector.<ShineSelectButton> = new Vector.<ShineSelectButton>();
            var _local_4:int;
            while (_local_4 < this._btns.length)
            {
                if (this._btns[_local_4].visible)
                {
                    _local_3.push(this._btns[_local_4]);
                };
                _local_4++;
            };
            switch (_local_3.length)
            {
                case 0:
                    return;
                case 1:
                    _local_3[0].x = 224;
                    _local_3[0].y = 394;
                    return;
                case 2:
                    _local_3[0].x = this._rect2.x;
                    _local_3[1].x = this._rect2.y;
                    _local_3[0].y = (_local_3[1].y = (this._rect2.y + 42));
                    return;
                case 3:
                    _local_3[0].x = this._rect3.x;
                    _local_3[1].x = this._rect3.y;
                    _local_3[2].x = this._rect3.width;
                    _local_3[0].y = (_local_3[1].y = (_local_3[2].y = (this._rect3.y + 148)));
                    return;
                case 4:
                    _local_3[0].x = this._rect1.x;
                    _local_3[1].x = this._rect1.y;
                    _local_3[2].x = this._rect1.width;
                    _local_3[3].x = this._rect1.height;
                    _local_3[0].y = (_local_3[1].y = (_local_3[2].y = (_local_3[3].y = (this._rect1.y + 148))));
                    return;
            };
        }

        private function __onTitleComplete(_arg_1:LoaderEvent):void
        {
            if ((((this._dungeonTitle) && (this._titleLoader)) && (this._titleLoader.content)))
            {
                ObjectUtils.disposeAllChildren(this._dungeonTitle);
                this._dungeonTitle.addChild(Bitmap(this._titleLoader.content));
                this._titleLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onTitleComplete);
                this._titleLoader = null;
            };
        }

        private function __onPreViewComplete(_arg_1:LoaderEvent):void
        {
            if ((((this._dungeonPreView) && (this._preViewLoader)) && (this._preViewLoader.content)))
            {
                ObjectUtils.disposeAllChildren(this._dungeonPreView);
                this._dungeonPreView.addChild(Bitmap(this._preViewLoader.content));
                this._preViewLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onPreViewComplete);
                this._preViewLoader = null;
            };
        }

        public function dispose():void
        {
            var _local_1:DungeonMapItem;
            this.removeEvents();
            for each (_local_1 in this._maps)
            {
                _local_1.removeEventListener(Event.SELECT, this.__onItemSelect);
            };
            this._titleLoader = null;
            this._preViewLoader = null;
            if (this._modebg)
            {
                ObjectUtils.disposeObject(this._modebg);
            };
            this._modebg = null;
            if (this._modeline)
            {
                ObjectUtils.disposeObject(this._modeline);
            };
            this._modeline = null;
            if (this._roomMode)
            {
                ObjectUtils.disposeObject(this._roomMode);
            };
            this._roomMode = null;
            if (this._roomName)
            {
                ObjectUtils.disposeObject(this._roomName);
            };
            this._roomName = null;
            if (this._roomPass)
            {
                ObjectUtils.disposeObject(this._roomPass);
            };
            this._roomPass = null;
            if (this._nameInput)
            {
                ObjectUtils.disposeObject(this._nameInput);
            };
            this._nameInput = null;
            if (this._passInput)
            {
                ObjectUtils.disposeObject(this._passInput);
            };
            this._passInput = null;
            if (this._checkBox)
            {
                ObjectUtils.disposeObject(this._checkBox);
            };
            this._checkBox = null;
            if (this._modeDescriptionTxt)
            {
                ObjectUtils.disposeObject(this._modeDescriptionTxt);
            };
            this._modeDescriptionTxt = null;
            if (this._fbMode)
            {
                ObjectUtils.disposeObject(this._fbMode);
            };
            this._fbMode = null;
            if (this._bigBg)
            {
                ObjectUtils.disposeObject(this._bigBg);
            };
            this._bigBg = null;
            if (this._line)
            {
                ObjectUtils.disposeObject(this._line);
            };
            this._line = null;
            if (this._dungeonList)
            {
                ObjectUtils.disposeObject(this._dungeonList);
            };
            this._dungeonList = null;
            if (this._dungeonListContainer)
            {
                ObjectUtils.disposeObject(this._dungeonListContainer);
            };
            this._dungeonListContainer = null;
            if (this._dungeonPreView)
            {
                ObjectUtils.disposeObject(this._dungeonPreView);
            };
            this._dungeonPreView = null;
            if (this._dungeonTitle)
            {
                ObjectUtils.disposeObject(this._dungeonTitle);
            };
            this._dungeonTitle = null;
            if (this._dungeonDescriptionTxt)
            {
                ObjectUtils.disposeObject(this._dungeonDescriptionTxt);
            };
            this._dungeonDescriptionTxt = null;
            if (this._btnGroup)
            {
                ObjectUtils.disposeObject(this._btnGroup);
            };
            this._btnGroup = null;
            if (this._mapTypBtn_n)
            {
                ObjectUtils.disposeObject(this._mapTypBtn_n);
            };
            this._mapTypBtn_n = null;
            if (this._mapTypBtn_s)
            {
                ObjectUtils.disposeObject(this._mapTypBtn_s);
            };
            this._mapTypBtn_s = null;
            if (this._group)
            {
                ObjectUtils.disposeObject(this._group);
            };
            this._group = null;
            if (this._easyBtn)
            {
                ObjectUtils.disposeObject(this._easyBtn);
            };
            this._easyBtn = null;
            if (this._normalBtn)
            {
                ObjectUtils.disposeObject(this._normalBtn);
            };
            this._normalBtn = null;
            if (this._hardBtn)
            {
                ObjectUtils.disposeObject(this._hardBtn);
            };
            this._hardBtn = null;
            if (this._heroBtn)
            {
                ObjectUtils.disposeObject(this._heroBtn);
            };
            this._heroBtn = null;
            if (this._bossBtn)
            {
                ObjectUtils.disposeObject(this._bossBtn);
            };
            this._bossBtn = null;
            if (this._bossBtnStrip)
            {
                ObjectUtils.disposeObject(this._bossBtnStrip);
            };
            this._bossBtnStrip = null;
            ObjectUtils.disposeObject(this._timeTxt);
            this._timeTxt = null;
            var _local_2:int;
            while (_local_2 < this._btns.length)
            {
                if (this._btns[_local_2])
                {
                    ObjectUtils.disposeObject(this._btns[_local_2]);
                };
                this._btns[_local_2] = null;
                _local_2++;
            };
            this._btns = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function checkState():Boolean
        {
            if ((!(this._currentSelectedItem)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.selectDuplicate"));
                this._bossBtn.selected = false;
                this.shineMap();
                return (false);
            };
            if ((!(MapManager.getDungeonInfo(this._currentSelectedItem.mapId).isOpen)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.duplicate.notOpen"));
                return (false);
            };
            if (this._selectedLevel < 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomMapSetPanelDuplicate.choicePermissionType"));
                this._bossBtn.selected = false;
                this.shineLevelBtn();
                return (false);
            };
            if (FilterWordManager.IsNullorEmpty(this._nameInput.text))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
                SoundManager.instance.play("008");
                return (false);
            };
            if (FilterWordManager.isGotForbiddenWords(this._nameInput.text, "name"))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
                SoundManager.instance.play("008");
                return (false);
            };
            if (((this._checkBox.selected) && (FilterWordManager.IsNullorEmpty(this._passInput.text))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
                SoundManager.instance.play("008");
                return (false);
            };
            return (true);
        }

        private function shineMap():void
        {
            var _local_1:DungeonMapItem;
            for each (_local_1 in this._maps)
            {
                if (_local_1.mapId > 0)
                {
                    _local_1.shine();
                };
            };
        }

        private function stopShineMap():void
        {
            var _local_1:DungeonMapItem;
            for each (_local_1 in this._maps)
            {
                _local_1.stopShine();
            };
        }

        private function shineLevelBtn():void
        {
            var _local_1:ShineSelectButton;
            for each (_local_1 in this._btns)
            {
                if (_local_1.enable)
                {
                    _local_1.shine();
                };
            };
        }

        private function stopShineLevelBtn():void
        {
            var _local_1:ShineSelectButton;
            for each (_local_1 in this._btns)
            {
                _local_1.stopShine();
            };
        }

        public function get selectedMapID():int
        {
            return ((this._currentSelectedItem) ? this._currentSelectedItem.mapId : 0);
        }

        public function get selectedLevel():int
        {
            return (this._selectedLevel);
        }


    }
}//package room.view.chooseMap

