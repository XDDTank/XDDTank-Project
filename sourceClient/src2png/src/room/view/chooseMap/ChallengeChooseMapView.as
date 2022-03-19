// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.chooseMap.ChallengeChooseMapView

package room.view.chooseMap
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.controls.SelectedButton;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.loader.DisplayLoader;
    import __AS3__.vec.Vector;
    import ddt.data.map.MapInfo;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import room.RoomManager;
    import ddt.manager.MapManager;
    import ddt.loader.MapSmallIcon;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.utils.FilterWordManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.GameInSocketOut;
    import room.model.RoomInfo;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.PathManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.toplevel.StageReferance;
    import __AS3__.vec.*;

    public class ChallengeChooseMapView extends Sprite implements Disposeable 
    {

        private var _frame:BaseAlerFrame;
        private var _roomMode:Bitmap;
        private var _challenge:Bitmap;
        private var _roomModeBg:Bitmap;
        private var _modeline:Bitmap;
        private var _roomName:FilterFrameText;
        private var _roomPass:FilterFrameText;
        private var _nameInput:TextInput;
        private var _passInput:TextInput;
        private var _checkBox:SelectedCheckButton;
        private var _timeTxt:FilterFrameText;
        private var _roundTime5sec:SelectedButton;
        private var _roundTime7sec:SelectedButton;
        private var _roundTime10sec:SelectedButton;
        private var _roundTimeGroup:SelectedButtonGroup;
        private var _chooseMap:Bitmap;
        private var _mapsBg:MutipleImage;
        private var _mapList:SimpleTileList;
        private var _srollPanel:ScrollPanel;
        private var _mapDecription:TextArea;
        private var _mapPreview:Sprite;
        private var _titlePreview:Sprite;
        private var _previewLoader:DisplayLoader;
        private var _titleLoader:DisplayLoader;
        private var _currentSelectedItem:BaseMapItem;
        private var _mapInfoList:Vector.<MapInfo>;
        private var _mapId:int;
        private var _isReset:Boolean;
        private var _isChanged:Boolean = false;

        public function ChallengeChooseMapView()
        {
            this.init();
        }

        private function init():void
        {
            var _local_2:MapInfo;
            var _local_3:DisplayObject;
            var _local_4:BaseMapItem;
            this._frame = ComponentFactory.Instance.creatComponentByStylename("asset.ddtChallengeRoom.chooseMapFrame");
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.title = LanguageMgr.GetTranslation("tank.room.RoomIIMapSetPanel.room");
            _local_1.showCancel = (_local_1.moveEnable = false);
            _local_1.submitLabel = LanguageMgr.GetTranslation("ok");
            this._frame.info = _local_1;
            this._titlePreview = new Sprite();
            this._mapInfoList = new Vector.<MapInfo>();
            this._roundTimeGroup = new SelectedButtonGroup();
            this._roomModeBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.challenge.modebg");
            this._roomMode = ComponentFactory.Instance.creatBitmap("asset.ddtroom.challenge.roomMode");
            this._modeline = ComponentFactory.Instance.creatBitmap("asset.ddtroom.selectedMapLine");
            PositionUtils.setPos(this._modeline, "asset.ddtroom.challenge.chooseMap.line");
            this._challenge = ComponentFactory.Instance.creatBitmap("asset.ddtroom.challenge.challenge");
            this._roomName = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.name");
            PositionUtils.setPos(this._roomName, "asset.ddtroom.challenge.chooseMap.roomName");
            this._roomName.text = LanguageMgr.GetTranslation("ddt.matchRoom.setView.roomname");
            this._roomPass = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.password");
            PositionUtils.setPos(this._roomPass, "asset.ddtroom.challenge.chooseMap.roomPass");
            this._roomPass.text = LanguageMgr.GetTranslation("ddt.matchRoom.setView.password");
            this._nameInput = ComponentFactory.Instance.creatComponentByStylename("asset.ddtRoom.dungeon.ChooseMap.nameInput");
            this._nameInput.textField.multiline = false;
            this._nameInput.textField.wordWrap = false;
            PositionUtils.setPos(this._nameInput, "asset.ddtroom.challenge.chooseMap.nameInput");
            this._passInput = ComponentFactory.Instance.creatComponentByStylename("asset.ddtRoom.dungeon.ChooseMap.passInput");
            this._passInput.textField.restrict = "0-9A-Za-z";
            PositionUtils.setPos(this._passInput, "asset.ddtroom.challenge.chooseMap.passInput");
            this._checkBox = ComponentFactory.Instance.creatComponentByStylename("asset.ddtMatchRoom.setView.selectBtn");
            PositionUtils.setPos(this._checkBox, "asset.ddtroom.challenge.chooseMap.chockBox");
            this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.challenge.timeTxt");
            this._timeTxt.text = LanguageMgr.GetTranslation("ddt.matchRoom.setView.label");
            this._roundTime5sec = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.challenge.chooseMap.5SecondSBtn");
            this._roundTime7sec = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.challenge.chooseMap.7SecondSBtn");
            this._roundTime10sec = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.challenge.chooseMap.10SecondSBtn");
            this._roundTime5sec.displacement = (this._roundTime7sec.displacement = (this._roundTime10sec.displacement = false));
            this._roundTimeGroup.addSelectItem(this._roundTime5sec);
            this._roundTimeGroup.addSelectItem(this._roundTime7sec);
            this._roundTimeGroup.addSelectItem(this._roundTime10sec);
            this._roundTimeGroup.selectIndex = ((RoomManager.Instance.current.timeType == -1) ? 1 : (RoomManager.Instance.current.timeType - 1));
            this._frame.addToContent(this._roomModeBg);
            this._frame.addToContent(this._roomMode);
            this._frame.addToContent(this._modeline);
            this._frame.addToContent(this._challenge);
            this._frame.addToContent(this._roomName);
            this._frame.addToContent(this._roomPass);
            this._frame.addToContent(this._nameInput);
            this._frame.addToContent(this._passInput);
            this._frame.addToContent(this._checkBox);
            this._frame.addToContent(this._timeTxt);
            this._frame.addToContent(this._roundTime5sec);
            this._frame.addToContent(this._roundTime7sec);
            this._frame.addToContent(this._roundTime10sec);
            this._chooseMap = ComponentFactory.Instance.creatBitmap("asset.ddtroom.challenge.chooseMap");
            this._mapsBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.challenge.chooseMap.mapsBg");
            this._mapList = new SimpleTileList(4);
            this._mapList.vSpace = (this._mapList.hSpace = -9);
            this._mapList.startPos = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.challenge.chooseMap.listPos");
            this._srollPanel = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.challengeMapSetScrollPanel");
            this._srollPanel.setView(this._mapList);
            this._mapDecription = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.dungeon.ChooseMap.descriptArea");
            this._mapDecription.textField.selectable = false;
            PositionUtils.setPos(this._mapDecription, "asset.ddtroom.challenge.chooseMap.mapDecriptionPos");
            this._titlePreview = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.chooseDungeonTitle");
            PositionUtils.setPos(this._titlePreview, "asset.ddtroom.challenge.chooseMap.titlePreviewPos");
            this._mapPreview = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.chooseDungeonPreView");
            PositionUtils.setPos(this._mapPreview, "asset.ddtroom.challenge.chooseMap.mapPreviewPos");
            this._frame.addToContent(this._mapsBg);
            this._frame.addToContent(this._chooseMap);
            this._frame.addToContent(this._srollPanel);
            this._frame.addToContent(this._mapDecription);
            this._frame.addToContent(this._titlePreview);
            this._frame.addToContent(this._mapPreview);
            this._mapInfoList = MapManager.getListByType(MapManager.PVP_TRAIN_MAP);
            for each (_local_2 in this._mapInfoList)
            {
                if (!(((!(_local_2.Type == 0)) && (!(_local_2.Type == 1))) && (!(_local_2.Type == 3))))
                {
                    if (!(!(_local_2.canSelect)))
                    {
                        _local_3 = new MapSmallIcon(_local_2.ID);
                        if (_local_3 != null)
                        {
                            _local_4 = new BaseMapItem();
                            if (_local_2.ID == RoomManager.Instance.current.mapId)
                            {
                                _local_4.selected = true;
                                this._currentSelectedItem = _local_4;
                                this._mapId = _local_2.ID;
                            };
                            if (_local_2.isOpen)
                            {
                                _local_4.mapId = _local_2.ID;
                                _local_4.addEventListener(Event.SELECT, this.__mapItemClick);
                                this._mapList.addChild(_local_4);
                            };
                        };
                    };
                };
            };
            addChild(this._frame);
            this.updatePreview();
            this.updateDescription();
            this.updateRoomInfo();
            this._roundTime5sec.addEventListener(MouseEvent.CLICK, this.__roundTimeClick);
            this._roundTime7sec.addEventListener(MouseEvent.CLICK, this.__roundTimeClick);
            this._roundTime10sec.addEventListener(MouseEvent.CLICK, this.__roundTimeClick);
            this._checkBox.addEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            this._frame.addEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
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

        private function __checkBoxClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.upadtePassTextBg();
        }

        private function upadtePassTextBg():void
        {
            if (this._checkBox.selected)
            {
                this._passInput.setFocus();
                this._passInput.mouseChildren = true;
                this._passInput.mouseEnabled = true;
            }
            else
            {
                this._passInput.text = "";
                this._passInput.mouseChildren = false;
                this._passInput.mouseEnabled = false;
            };
        }

        private function __roundTimeClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._isChanged = true;
        }

        private function __frameEventHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                    if (FilterWordManager.IsNullorEmpty(this._nameInput.text))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
                        SoundManager.instance.play("008");
                    }
                    else
                    {
                        if (FilterWordManager.isGotForbiddenWords(this._nameInput.text, "name"))
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
                            SoundManager.instance.play("008");
                        }
                        else
                        {
                            if (((this._checkBox.selected) && (FilterWordManager.IsNullorEmpty(this._passInput.text))))
                            {
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
                                SoundManager.instance.play("008");
                            }
                            else
                            {
                                GameInSocketOut.sendGameRoomSetUp(this._mapId, RoomInfo.CHALLENGE_ROOM, false, this._passInput.text, this._nameInput.text, (this._roundTimeGroup.selectIndex + 1), 0, 0, false, 0);
                                RoomManager.Instance.current.roomName = this._nameInput.text;
                                RoomManager.Instance.current.roomPass = this._passInput.text;
                                this.dispose();
                            };
                        };
                    };
                    return;
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    return;
            };
        }

        public function set mapId(_arg_1:int):void
        {
            if (_arg_1 != this._mapId)
            {
                this._mapId = _arg_1;
            };
        }

        private function updatePreview():void
        {
            ObjectUtils.disposeAllChildren(this._mapPreview);
            this._previewLoader = LoadResourceManager.instance.createLoader(this.solvePreviewPath(), BaseLoader.BITMAP_LOADER);
            this._previewLoader.addEventListener(LoaderEvent.COMPLETE, this.__onPreviewComplete);
            LoadResourceManager.instance.startLoad(this._previewLoader);
        }

        private function updateDescription():void
        {
            ObjectUtils.disposeAllChildren(this._titlePreview);
            this._titleLoader = LoadResourceManager.instance.createLoader(this.solveTitlePath(), BaseLoader.BITMAP_LOADER);
            this._titleLoader.addEventListener(LoaderEvent.COMPLETE, this.__onTitleComplete);
            LoadResourceManager.instance.startLoad(this._titleLoader);
            if (this._currentSelectedItem)
            {
                this._mapDecription.text = MapManager.getMapInfo(this._currentSelectedItem.mapId).Description;
            }
            else
            {
                this._mapDecription.text = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
            };
        }

        private function __mapItemClick(_arg_1:*):void
        {
            if (this._isReset)
            {
                this._isReset = false;
                return;
            };
            this._isChanged = true;
            if (this._currentSelectedItem)
            {
                this._currentSelectedItem.selected = false;
            };
            this._currentSelectedItem = (_arg_1.target as BaseMapItem);
            this.mapId = this._currentSelectedItem.mapId;
            this.updateDescription();
            this.updatePreview();
        }

        private function solvePreviewPath():String
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

        private function solveTitlePath():String
        {
            var _local_1:String = (PathManager.SITE_MAIN + "image/map/");
            if (this._currentSelectedItem)
            {
                _local_1 = (_local_1 + (this._currentSelectedItem.mapId.toString() + "/icon.png"));
            }
            else
            {
                _local_1 = (_local_1 + "0/icon.png");
            };
            return (_local_1);
        }

        private function __onPreviewComplete(_arg_1:LoaderEvent):void
        {
            if (_arg_1.currentTarget.isSuccess)
            {
                if (this._mapPreview)
                {
                    this._mapPreview.addChild(Bitmap(_arg_1.currentTarget.content));
                };
            };
        }

        private function __onTitleComplete(_arg_1:LoaderEvent):void
        {
            if (_arg_1.currentTarget.isSuccess)
            {
                if (this._titlePreview)
                {
                    this._titlePreview.addChild(Bitmap(_arg_1.currentTarget.content));
                };
            };
        }

        public function show():void
        {
            var _local_1:int;
            while (_local_1 < this._mapList.numChildren)
            {
                (this._mapList.getChildAt(_local_1) as BaseMapItem).selected = false;
                if ((this._mapList.getChildAt(_local_1) as BaseMapItem).mapId == RoomManager.Instance.current.mapId)
                {
                    this._isReset = true;
                    this._currentSelectedItem = (this._mapList.getChildAt(_local_1) as BaseMapItem);
                    this._currentSelectedItem.selected = true;
                    this.mapId = this._currentSelectedItem.mapId;
                    this.updateDescription();
                    this.updatePreview();
                };
                _local_1++;
            };
            this._roundTimeGroup.selectIndex = ((RoomManager.Instance.current.timeType == -1) ? 1 : (RoomManager.Instance.current.timeType - 1));
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            StageReferance.stage.focus = this._frame;
            this._nameInput.text = RoomManager.Instance.current.Name;
            this.updateRoomInfo();
        }

        public function dispose():void
        {
            var _local_1:BaseMapItem;
            while (this._mapList.numChildren)
            {
                _local_1 = (this._mapList.getChildAt(0) as BaseMapItem);
                _local_1.removeEventListener(Event.SELECT, this.__mapItemClick);
                this._mapList.removeChild(_local_1);
            };
            this._roundTime5sec.removeEventListener(MouseEvent.CLICK, this.__roundTimeClick);
            this._roundTime7sec.removeEventListener(MouseEvent.CLICK, this.__roundTimeClick);
            this._roundTime10sec.removeEventListener(MouseEvent.CLICK, this.__roundTimeClick);
            this._frame.removeEventListener(FrameEvent.RESPONSE, this.__frameEventHandler);
            this._previewLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onPreviewComplete);
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onTitleComplete);
            this._checkBox.removeEventListener(MouseEvent.CLICK, this.__checkBoxClick);
            if (this._roomPass)
            {
                ObjectUtils.disposeObject(this._roomPass);
            };
            this._roomPass = null;
            if (this._roomMode)
            {
                ObjectUtils.disposeObject(this._roomMode);
            };
            this._roomMode = null;
            if (this._modeline)
            {
                ObjectUtils.disposeObject(this._modeline);
            };
            this._modeline = null;
            if (this._challenge)
            {
                ObjectUtils.disposeObject(this._challenge);
            };
            this._challenge = null;
            if (this._roomModeBg)
            {
                ObjectUtils.disposeObject(this._roomModeBg);
            };
            this._roomModeBg = null;
            if (this._roomName)
            {
                ObjectUtils.disposeObject(this._roomName);
            };
            this._roomName = null;
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
            if (this._timeTxt)
            {
                ObjectUtils.disposeObject(this._timeTxt);
            };
            this._timeTxt = null;
            this._roundTimeGroup.dispose();
            this._roundTimeGroup = null;
            if (this._roundTime5sec)
            {
                ObjectUtils.disposeObject(this._roundTime5sec);
            };
            this._roundTime5sec = null;
            if (this._roundTime7sec)
            {
                ObjectUtils.disposeObject(this._roundTime7sec);
            };
            this._roundTime7sec = null;
            if (this._roundTime10sec)
            {
                ObjectUtils.disposeObject(this._roundTime10sec);
            };
            this._roundTime10sec = null;
            if (this._chooseMap)
            {
                ObjectUtils.disposeObject(this._chooseMap);
            };
            this._chooseMap = null;
            if (this._mapsBg)
            {
                ObjectUtils.disposeObject(this._mapsBg);
            };
            this._mapsBg = null;
            if (this._mapList)
            {
                ObjectUtils.disposeObject(this._mapList);
            };
            this._mapList = null;
            if (this._srollPanel)
            {
                ObjectUtils.disposeObject(this._srollPanel);
            };
            this._srollPanel = null;
            if (this._mapDecription)
            {
                ObjectUtils.disposeObject(this._mapDecription);
            };
            this._mapDecription = null;
            if (this._mapPreview)
            {
                ObjectUtils.disposeObject(this._mapPreview);
            };
            this._mapPreview = null;
            if (this._titlePreview)
            {
                ObjectUtils.disposeObject(this._titlePreview);
            };
            this._titlePreview = null;
            if (this._currentSelectedItem)
            {
                ObjectUtils.disposeObject(this._currentSelectedItem);
            };
            this._currentSelectedItem = null;
            this._previewLoader = null;
            this._titleLoader = null;
            if (this._frame)
            {
                ObjectUtils.disposeObject(this._frame);
            };
            this._frame = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view.chooseMap

