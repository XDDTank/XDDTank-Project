package roomList.pvpRoomList
{
   import arena.ArenaManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import room.model.RoomInfo;
   import roomList.LookupEnumerate;
   import roomList.LookupRoomView;
   
   public class RoomListBGView extends Sprite implements Disposeable
   {
      
      public static var PREWORD:Array = [LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.tank"),LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.go"),LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.fire")];
      
      public static const FULL_MODE:int = 2;
      
      public static const ATHLETICS_MODE:int = 0;
      
      public static const CHALLENGE_MODE:int = 1;
       
      
      private var _roomListBG:Bitmap;
      
      private var _titleBg:Bitmap;
      
      private var _itemlistBg:MutipleImage;
      
      private var _itemlistBg2:ScaleLeftRightImage;
      
      private var _title:Bitmap;
      
      private var _listTitle:Bitmap;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _mutiBtn:SimpleBitmapButton;
      
      private var _singleBtn:SimpleBitmapButton;
      
      private var _lookUpBtn:SimpleBitmapButton;
      
      private var _itemList:SimpleTileList;
      
      private var _itemArray:Array;
      
      private var _model:RoomListModel;
      
      private var _controller:RoomListController;
      
      private var _tempDataList:Array;
      
      private var _modeMenu:ComboBox;
      
      private var _currentMode:int;
      
      private var _isPermissionEnter:Boolean;
      
      private var _modeArray:Array;
      
      private var _buttonBg:Scale9CornerImage;
      
      private var _createBtn:BaseButton;
      
      private var _arenaBtn:BaseButton;
      
      private var _refreshBtn:TextButton;
      
      private var _lookupRoom:LookupRoomView;
      
      private var _Verticalline:Bitmap;
      
      private var _expeditionAlert:BaseAlerFrame;
      
      private var _randomlist:DictionaryData;
      
      private var _selectItemPos:int;
      
      private var _selectItemID:int;
      
      private var _lastClick:Number;
      
      private var _lastCreatTime:int = 0;
      
      public function RoomListBGView(param1:RoomListController, param2:RoomListModel)
      {
         this._modeArray = ["ddt.roomList.roomListBG.Athletics","ddt.roomList.roomListBG.challenge","ddt.roomList.roomListBG.full"];
         this._randomlist = new DictionaryData();
         this._model = param2;
         this._controller = param1;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._roomListBG = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.Mainbg");
         this._Verticalline = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.line2");
         this._buttonBg = ComponentFactory.Instance.creatComponentByStylename("ddtroomlist.btnBg");
         this._itemlistBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlistBg");
         this._itemlistBg2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlistBg2");
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.ddtcivil.titleBg");
         PositionUtils.setPos(this._titleBg,"asset.ddtRoomlist.pvp.titlebgpos");
         this._title = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.right.title");
         this._listTitle = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.right.listtitle");
         this._modeMenu = ComponentFactory.Instance.creatComponentByStylename("asset.ddtRoomlist.pvp.modeMenu");
         this._modeMenu.textField.text = LanguageMgr.GetTranslation(this._modeArray[FULL_MODE]);
         this._lookupRoom = ComponentFactory.Instance.creatCustomObject("ddtroomlistLookupRoomView",[0]);
         this._model.currentType = FULL_MODE;
         this._itemArray = [];
         this._itemList = ComponentFactory.Instance.creat("asset.ddtRoomList.pvp.itemContainer",[3]);
         this.updateList();
         addChild(this._roomListBG);
         addChild(this._Verticalline);
         addChild(this._buttonBg);
         addChild(this._modeMenu);
         addChild(this._lookupRoom);
         addChild(this._itemList);
         this.initButton();
         this._isPermissionEnter = true;
      }
      
      private function initButton() : void
      {
         this._createBtn = ComponentFactory.Instance.creatComponentByStylename("ddtroomList.openBtn");
         this._refreshBtn = ComponentFactory.Instance.creatComponentByStylename("ddtroomlist.roomRefresh_btn");
         this._refreshBtn.text = LanguageMgr.GetTranslation("ddt.roomList.refreshTxt");
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.nextBtn");
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.preBtn");
         this._singleBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.singleBtn");
         this._singleBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinSingleBattle");
         this._mutiBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.mutiBtn");
         this._mutiBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinMutiBattle");
         this._lookUpBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.searchBtn");
         this._lookUpBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.findRoom");
         this._arenaBtn = ComponentFactory.Instance.creatComponentByStylename("ddtroomList.arenaBtn");
         this.addTipPanel();
         addChild(this._createBtn);
         addChild(this._arenaBtn);
         addChild(this._refreshBtn);
         this._mutiBtn.mouseEnabled = false;
         this._mutiBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         if(PlayerManager.Instance.Self.Grade >= 13)
         {
            this._mutiBtn.mouseEnabled = true;
            this._mutiBtn.filters = null;
         }
      }
      
      private function initEvent() : void
      {
         this._createBtn.addEventListener(MouseEvent.CLICK,this._mutiBtnClick);
         this._refreshBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._singleBtn.addEventListener(MouseEvent.CLICK,this.__singleBtnClick);
         this._mutiBtn.addEventListener(MouseEvent.CLICK,this._mutiBtnClick);
         this._lookUpBtn.addEventListener(MouseEvent.CLICK,this.__lookupClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._model.addEventListener(RoomListModel.ROOM_ITEM_UPDATE,this.__updateItem);
         this._model.getRoomList().addEventListener(DictionaryEvent.CLEAR,this.__clearRoom);
         this._modeMenu.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
         this._modeMenu.button.addEventListener(MouseEvent.CLICK,this.__clickMenuBtn);
         this._arenaBtn.addEventListener(MouseEvent.CLICK,this.__arenaClick);
      }
      
      private function removeEvent() : void
      {
         this._createBtn.removeEventListener(MouseEvent.CLICK,this._mutiBtnClick);
         this._arenaBtn.removeEventListener(MouseEvent.CLICK,this.__arenaClick);
         this._refreshBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._singleBtn.removeEventListener(MouseEvent.CLICK,this.__singleBtnClick);
         this._mutiBtn.removeEventListener(MouseEvent.CLICK,this._mutiBtnClick);
         this._lookUpBtn.removeEventListener(MouseEvent.CLICK,this.__lookupClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._model.removeEventListener(RoomListModel.ROOM_ITEM_UPDATE,this.__updateItem);
         this._modeMenu.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListClick);
         this._modeMenu.button.removeEventListener(MouseEvent.CLICK,this.__clickMenuBtn);
         if(this._model.getRoomList())
         {
            this._model.getRoomList().removeEventListener(DictionaryEvent.CLEAR,this.__clearRoom);
         }
      }
      
      private function __updateItem(param1:Event) : void
      {
         this.upadteItemPos();
         this._isPermissionEnter = true;
      }
      
      private function __onListClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.currentType = this.getCurrentMode(param1.cellValue);
         this.addTipPanel();
      }
      
      private function __clickMenuBtn(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function getCurrentMode(param1:String) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._modeArray.length)
         {
            if(LanguageMgr.GetTranslation(this._modeArray[_loc2_]) == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function addTipPanel() : void
      {
         var _loc1_:VectorListModel = this._modeMenu.listPanel.vectorListModel;
         _loc1_.clear();
         switch(this._model.currentType)
         {
            case FULL_MODE:
               _loc1_.append(LanguageMgr.GetTranslation(this._modeArray[ATHLETICS_MODE]));
               _loc1_.append(LanguageMgr.GetTranslation(this._modeArray[CHALLENGE_MODE]));
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFAULT);
               break;
            case ATHLETICS_MODE:
               _loc1_.append(LanguageMgr.GetTranslation(this._modeArray[FULL_MODE]));
               _loc1_.append(LanguageMgr.GetTranslation(this._modeArray[CHALLENGE_MODE]));
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_ATHLETICTICS);
               break;
            case CHALLENGE_MODE:
               _loc1_.append(LanguageMgr.GetTranslation(this._modeArray[FULL_MODE]));
               _loc1_.append(LanguageMgr.GetTranslation(this._modeArray[ATHLETICS_MODE]));
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFY);
         }
      }
      
      private function __clearRoom(param1:DictionaryEvent) : void
      {
         this.cleanItem();
         this._isPermissionEnter = true;
      }
      
      private function updateList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RoomInfo = null;
         var _loc3_:RoomListItemView = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:RoomInfo = null;
         var _loc7_:RoomListItemView = null;
         this.cleanItem();
         if(this._model.getRoomList().length == 0)
         {
            this.randomRoomlist();
         }
         else if(this._model.getRoomList().length < 6)
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               if(_loc1_ < this._model.getRoomList().length)
               {
                  _loc2_ = this._model.getRoomList().list[_loc1_];
                  if(_loc2_)
                  {
                     _loc3_ = new RoomListItemView(_loc2_);
                     _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClick);
                     this._itemList.addChild(_loc3_);
                     this._itemArray.push(_loc3_);
                  }
               }
               else
               {
                  this.randomRoomlist();
               }
               _loc1_++;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < this._model.getPlayerList().length)
            {
               _loc4_++;
               if(_loc4_ >= 7)
               {
                  break;
               }
               _loc6_ = this._model.getRoomList().list[_loc1_];
               if(_loc6_)
               {
                  _loc7_ = new RoomListItemView(_loc6_);
                  _loc7_.addEventListener(MouseEvent.CLICK,this.__itemClick);
                  this._itemList.addChild(_loc7_);
                  this._itemArray.push(_loc7_);
               }
               _loc5_++;
            }
         }
      }
      
      private function randomRoomlist() : void
      {
         var _loc2_:RoomInfo = null;
         var _loc3_:RoomListItemView = null;
         this.randomList.clear();
         var _loc1_:int = 0;
         while(_loc1_ < 6 - this._model.getRoomList().length)
         {
            _loc2_ = new RoomInfo();
            _loc2_.ID = this.randomRoomId();
            _loc2_.type = this.randomRoomtype();
            if(_loc2_.type == 1)
            {
               _loc2_.mapId = this.randomMapId();
            }
            _loc2_.isPlaying = true;
            _loc2_.totalPlayer = 3;
            _loc2_.placeCount = 3;
            _loc3_ = new RoomListItemView(_loc2_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClickOne);
            this._itemList.addChild(_loc3_);
            this._itemArray.push(_loc3_);
            _loc1_++;
         }
      }
      
      private function __itemClickOne(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         return MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomIsStart"));
      }
      
      private function getAllRoomId() : Vector.<int>
      {
         var _loc3_:RoomInfo = null;
         var _loc1_:Vector.<int> = new Vector.<int>();
         var _loc2_:DictionaryData = this._model.getRoomList();
         for each(_loc3_ in _loc2_)
         {
            _loc1_.push(_loc3_.ID);
         }
         return _loc1_;
      }
      
      public function get randomList() : DictionaryData
      {
         return this._randomlist;
      }
      
      public function set randomList(param1:DictionaryData) : void
      {
         this._randomlist = param1;
      }
      
      private function randomRoomId() : int
      {
         var _loc1_:int = 0;
         while(true)
         {
            _loc1_ = int(Math.random() * 100) + 1;
            if(!this._model.getRoomList().hasKey(_loc1_) && !this.randomList.hasKey(_loc1_))
            {
               this.randomList.add(_loc1_,_loc1_);
               break;
            }
         }
         return _loc1_;
      }
      
      private function randomRoomtype() : int
      {
         var _loc1_:int = 0;
         if(this._model.currentType == FULL_MODE)
         {
            _loc1_ = Math.random() * 2;
         }
         else
         {
            _loc1_ = this._model.currentType;
         }
         return _loc1_;
      }
      
      private function randomMapId() : int
      {
         var _loc1_:Array = ["1001","1002","1003","1004","1005","1006"];
         return int(_loc1_[Math.floor(Math.random() * _loc1_.length)]);
      }
      
      private function cleanItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemArray.length)
         {
            (this._itemArray[_loc1_] as RoomListItemView).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._itemArray[_loc1_] as RoomListItemView).dispose();
            _loc1_++;
         }
         this._itemList.disposeAllChildren();
         this._itemArray = [];
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         if(!this._isPermissionEnter)
         {
            return;
         }
         this.gotoIntoRoom((param1.currentTarget as RoomListItemView).info);
         this.getSelectItemPos((param1.currentTarget as RoomListItemView).id);
      }
      
      private function getSelectItemPos(param1:int) : int
      {
         if(!this._itemList)
         {
            return 0;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._itemArray.length)
         {
            if(!(this._itemArray[_loc2_] as RoomListItemView))
            {
               return 0;
            }
            if((this._itemArray[_loc2_] as RoomListItemView).id == param1)
            {
               this._selectItemPos = _loc2_;
               this._selectItemID = (this._itemArray[_loc2_] as RoomListItemView).id;
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function get currentDataList() : Array
      {
         if(this._model.roomShowMode == 1)
         {
            return this._model.getRoomList().filter("isPlaying",false).concat(this._model.getRoomList().filter("isPlaying",true));
         }
         return this._model.getRoomList().list;
      }
      
      private function getInfosPos(param1:int) : int
      {
         this._tempDataList = this.currentDataList;
         if(!this._tempDataList)
         {
            return 0;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._tempDataList.length)
         {
            if((this._tempDataList[_loc2_] as RoomInfo).ID == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      private function upadteItemPos() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RoomInfo = null;
         var _loc3_:RoomListItemView = null;
         var _loc4_:RoomInfo = null;
         var _loc5_:RoomListItemView = null;
         var _loc6_:int = 0;
         var _loc7_:RoomInfo = null;
         var _loc8_:RoomListItemView = null;
         this.cleanItem();
         this.randomList.clear();
         this._tempDataList = this.currentDataList;
         if(this._tempDataList)
         {
            if(this._tempDataList.length < 6)
            {
               _loc1_ = 0;
               while(_loc1_ < 6)
               {
                  if(_loc1_ < this._tempDataList.length)
                  {
                     _loc2_ = this._tempDataList[_loc1_];
                     if(_loc2_)
                     {
                        _loc3_ = new RoomListItemView(_loc2_);
                        _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClick);
                        this._itemList.addChild(_loc3_);
                        this._itemArray.push(_loc3_);
                     }
                  }
                  else
                  {
                     _loc4_ = new RoomInfo();
                     _loc4_.ID = this.randomRoomId();
                     _loc4_.type = this.randomRoomtype();
                     if(_loc4_.type == 1)
                     {
                        _loc4_.mapId = this.randomMapId();
                     }
                     _loc4_.isPlaying = true;
                     _loc4_.totalPlayer = 3;
                     _loc4_.placeCount = 3;
                     _loc5_ = new RoomListItemView(_loc4_);
                     _loc5_.addEventListener(MouseEvent.CLICK,this.__itemClickOne);
                     this._itemList.addChild(_loc5_);
                     this._itemArray.push(_loc5_);
                  }
                  _loc1_++;
               }
            }
            else
            {
               _loc6_ = 0;
               for each(_loc7_ in this._tempDataList)
               {
                  _loc6_++;
                  if(_loc6_ >= 7)
                  {
                     break;
                  }
                  if(_loc7_)
                  {
                     _loc8_ = new RoomListItemView(_loc7_);
                     _loc8_.addEventListener(MouseEvent.CLICK,this.__itemClick);
                     this._itemList.addChild(_loc8_);
                     this._itemArray.push(_loc8_);
                  }
               }
            }
         }
      }
      
      private function sortRooInfo(param1:Array) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:RoomInfo = null;
         var _loc2_:Array = new Array();
         switch(this._model.currentType)
         {
            case ATHLETICS_MODE:
               _loc3_ = 0;
               break;
            case CHALLENGE_MODE:
               _loc3_ = 1;
         }
         for each(_loc4_ in param1)
         {
            if(_loc4_)
            {
               if(_loc4_.type == _loc3_ && !_loc4_.isPlaying)
               {
                  _loc2_.unshift(_loc4_);
               }
               else
               {
                  _loc2_.push(_loc4_);
               }
            }
         }
         return _loc2_;
      }
      
      private function gotoTip(param1:int) : Boolean
      {
         if(param1 == 0)
         {
            if(PlayerManager.Instance.Self.Grade < 13)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.notGotoIntoRoom",13,LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.ream")));
               return true;
            }
         }
         else if(param1 == 1)
         {
            if(PlayerManager.Instance.Self.Grade < 13)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.notGotoIntoRoom",13,LanguageMgr.GetTranslation("tank.roomlist.challenge")));
               return true;
            }
         }
         return false;
      }
      
      public function gotoIntoRoom(param1:RoomInfo) : void
      {
         SoundManager.instance.play("008");
         if(this.gotoTip(param1.type))
         {
            return;
         }
         SocketManager.Instance.out.sendGameLogin(1,-1,param1.ID,"");
         this._isPermissionEnter = false;
      }
      
      private function __lookupClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controller.showFindRoom();
      }
      
      private function __singleBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isPermissionEnter)
         {
            return;
         }
         if(getTimer() - this._lastCreatTime > 2000)
         {
            this._lastCreatTime = getTimer();
            SoundManager.instance.play("008");
            if(PlayerManager.Instance.Self.Bag.getItemAt(14))
            {
               this._lastCreatTime = 0;
               GameInSocketOut.sendCreateRoom(RoomListCreateRoomView.PREWORD[int(Math.random() * RoomListCreateRoomView.PREWORD.length)],RoomInfo.SINGLE_ROOM,3,"");
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            }
         }
      }
      
      private function __updateClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._model.getRoomList().length == 0)
         {
            this.upadteItemPos();
            return;
         }
         this.sendUpdate();
      }
      
      private function __placeCountClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __hardLevelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __roomModeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __roomNameClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function __idBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendUpdate();
      }
      
      private function sendUpdate() : void
      {
         switch(this._model.currentType)
         {
            case FULL_MODE:
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFAULT);
               break;
            case ATHLETICS_MODE:
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_ATHLETICTICS);
               break;
            case CHALLENGE_MODE:
               SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.ROOM_LIST,LookupEnumerate.ROOMLIST_DEFY);
         }
      }
      
      private function _mutiBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._lastCreatTime > 2000)
         {
            this._lastCreatTime = getTimer();
            GameInSocketOut.sendCreateRoom(PREWORD[int(Math.random() * PREWORD.length)],RoomInfo.MATCH_ROOM,3);
         }
      }
      
      private function cleanRoomList() : void
      {
         this.randomList.clear();
         this.randomList = null;
      }
      
      private function __arenaClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.checkExpedition())
         {
            this._expeditionAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.BLCAK_BLOCKGOUND);
            this._expeditionAlert.moveEnable = false;
            this._expeditionAlert.addEventListener(FrameEvent.RESPONSE,this.__expeditionConfirmResponse);
         }
         else
         {
            ArenaManager.instance.enter();
         }
      }
      
      private function __expeditionConfirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__expeditionConfirmResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendExpeditionCancle();
            ArenaManager.instance.enter();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.cleanRoomList();
         this.cleanItem();
         if(this._Verticalline)
         {
            ObjectUtils.disposeObject(this._Verticalline);
         }
         this._Verticalline = null;
         if(this._itemlistBg2)
         {
            ObjectUtils.disposeObject(this._itemlistBg2);
         }
         this._itemlistBg2 = null;
         if(this._itemlistBg)
         {
            ObjectUtils.disposeObject(this._itemlistBg);
         }
         this._itemlistBg = null;
         if(this._roomListBG)
         {
            ObjectUtils.disposeObject(this._roomListBG);
         }
         this._roomListBG = null;
         if(this._buttonBg)
         {
            ObjectUtils.disposeObject(this._buttonBg);
         }
         this._buttonBg = null;
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(this._listTitle)
         {
            ObjectUtils.disposeObject(this._listTitle);
         }
         this._listTitle = null;
         if(this._createBtn)
         {
            ObjectUtils.disposeObject(this._createBtn);
         }
         this._createBtn = null;
         ObjectUtils.disposeObject(this._titleBg);
         this._titleBg = null;
         this._nextBtn.dispose();
         this._nextBtn = null;
         this._preBtn.dispose();
         this._preBtn = null;
         this._singleBtn.dispose();
         this._singleBtn = null;
         this._mutiBtn.dispose();
         this._mutiBtn = null;
         this._lookUpBtn.dispose();
         this._lookUpBtn = null;
         this._lookupRoom.dispose();
         this._lookupRoom = null;
         this._refreshBtn.dispose();
         this._refreshBtn = null;
         if(this._itemList)
         {
            this._itemList.disposeAllChildren();
         }
         ObjectUtils.disposeObject(this._itemList);
         this._tempDataList = null;
         this._itemList = null;
         this._itemArray = null;
         this._arenaBtn.dispose();
         this._arenaBtn = null;
         if(this._expeditionAlert)
         {
            this._expeditionAlert.removeEventListener(FrameEvent.RESPONSE,this.__expeditionConfirmResponse);
            ObjectUtils.disposeObject(this._expeditionAlert);
            this._expeditionAlert = null;
         }
         if(this._modeMenu)
         {
            ObjectUtils.disposeObject(this._modeMenu);
            this._modeMenu = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
