package roomList.pveRoomList
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Scrollbar;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomList.LookupEnumerate;
   import roomList.LookupRoomView;
   import roomList.RoomListMapTipPanel;
   import roomList.RoomListTipPanel;
   
   public class DungeonListBGView extends Sprite implements Disposeable
   {
      
      public static var PREWORD:Array = [LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.tank"),LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.go"),LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreatePveRoomView.fire")];
       
      
      private var _movieBg:Bitmap;
      
      private var _model:DungeonListModel;
      
      private var _btnSiftReset:TextButton;
      
      private var _bmpCbFb:BaseButton;
      
      private var _txtCbFb:FilterFrameText;
      
      private var _iconBtnII:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _rivalshipBtn:SimpleBitmapButton;
      
      private var _lookUpBtn:SimpleBitmapButton;
      
      private var _itemList:SimpleTileList;
      
      private var _itemArray:Array;
      
      private var _pveHardLeveRoomListTipPanel:RoomListTipPanel;
      
      private var _pveMapRoomListTipPanel:RoomListMapTipPanel;
      
      private var _controlle:DungeonListController;
      
      private var _tempDataList:Array;
      
      private var _isPermissionEnter:Boolean;
      
      private var _btnBg:Scale9CornerImage;
      
      private var _lookupRoom:LookupRoomView;
      
      private var _createBtn:BaseButton;
      
      private var _findBg:Bitmap;
      
      private var _Verticalline:Bitmap;
      
      private var _randomlist:DictionaryData;
      
      private var _selectItemPos:int;
      
      private var _selectItemID:int;
      
      private var _last_creat:uint;
      
      public function DungeonListBGView(param1:DungeonListController, param2:DungeonListModel)
      {
         this._randomlist = new DictionaryData();
         this._controlle = param1;
         this._model = param2;
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._itemArray = [];
         this._movieBg = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.moviebg");
         PositionUtils.setPos(this._movieBg,"asset.ddtRoomlist.pve.moviebgPos");
         addChild(this._movieBg);
         this._Verticalline = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.line2");
         addChild(this._Verticalline);
         this._btnSiftReset = ComponentFactory.Instance.creatComponentByStylename("ddtroomlist.roomRefresh_btn");
         this._btnSiftReset.text = LanguageMgr.GetTranslation("ddt.roomList.refreshTxt");
         PositionUtils.setPos(this._btnSiftReset,"asset.ddtdungeonroomList.roomRefreshBtnPos");
         addChild(this._btnSiftReset);
         this._bmpCbFb = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.bmpCbFb");
         addChild(this._bmpCbFb);
         this._txtCbFb = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.txtCbFb");
         this._txtCbFb.mouseEnabled = false;
         addChild(this._txtCbFb);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.nextBtn");
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.preBtn");
         this._rivalshipBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.quickBtn");
         this._rivalshipBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinDuplicateQuickly");
         this._lookUpBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.searchBtn");
         this._lookUpBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.findRoom");
         this._iconBtnII = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.itemlist.iconbtn2");
         addChild(this._iconBtnII);
         this._lookupRoom = ComponentFactory.Instance.creatCustomObject("ddtroomlistLookupRoomView",[1]);
         addChild(this._lookupRoom);
         PositionUtils.setPos(this._lookupRoom,"asset.ddtdungeonroomList.lookupRoomPos");
         var _loc1_:String = String(ServerManager.Instance.current.Name);
         var _loc2_:int = _loc1_.indexOf("(");
         _loc2_ = _loc2_ == -1 ? int(_loc1_.length) : int(_loc2_);
         this._itemList = ComponentFactory.Instance.creat("asset.ddtroomList.DungeonList.ItemList",[3]);
         addChild(this._itemList);
         this.updateList();
         this.addTipPanel();
         this.resetSift();
         this._isPermissionEnter = true;
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtdungeonroolist.btnBG");
         addChild(this._btnBg);
         this._createBtn = ComponentFactory.Instance.creatComponentByStylename("ddtroomList.openBtn");
         addChild(this._createBtn);
         PositionUtils.setPos(this._createBtn,"asset.ddtdungeonroomList.createBtnPos");
      }
      
      private function initEvent() : void
      {
         this._createBtn.addEventListener(MouseEvent.CLICK,this.__createClick);
         this._rivalshipBtn.addEventListener(MouseEvent.CLICK,this.__rivalshipBtnClick);
         this._iconBtnII.addEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._bmpCbFb.addEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._btnSiftReset.addEventListener(MouseEvent.CLICK,this.__siftReset);
         this._pveMapRoomListTipPanel.addEventListener(RoomListMapTipPanel.FB_CHANGE,this.__fbChange);
         this._pveHardLeveRoomListTipPanel.addEventListener(RoomListTipPanel.HARD_LV_CHANGE,this.__hardLvChange);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__updateClick);
         this._lookUpBtn.addEventListener(MouseEvent.CLICK,this.__lookupClick);
         this._model.addEventListener(DungeonListModel.DUNGEON_LIST_UPDATE,this.__addRoom);
         this._model.getRoomList().addEventListener(DictionaryEvent.CLEAR,this.__clearRoom);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__stageClick);
         RoomManager.Instance.addEventListener(RoomManager.LOGIN_ROOM_RESULT,this.__loginRoomRes);
      }
      
      private function removeEvent() : void
      {
         this._createBtn.removeEventListener(MouseEvent.CLICK,this.__createClick);
         this._rivalshipBtn.removeEventListener(MouseEvent.CLICK,this.__rivalshipBtnClick);
         this._iconBtnII.removeEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._bmpCbFb.removeEventListener(MouseEvent.CLICK,this.__iconBtnIIClick);
         this._btnSiftReset.removeEventListener(MouseEvent.CLICK,this.__siftReset);
         this._pveMapRoomListTipPanel.removeEventListener(RoomListMapTipPanel.FB_CHANGE,this.__fbChange);
         this._pveHardLeveRoomListTipPanel.removeEventListener(RoomListTipPanel.HARD_LV_CHANGE,this.__hardLvChange);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__updateClick);
         this._lookUpBtn.removeEventListener(MouseEvent.CLICK,this.__lookupClick);
         this._model.removeEventListener(DungeonListModel.DUNGEON_LIST_UPDATE,this.__addRoom);
         this._model.getRoomList().removeEventListener(DictionaryEvent.CLEAR,this.__clearRoom);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__stageClick);
         RoomManager.Instance.removeEventListener(RoomManager.LOGIN_ROOM_RESULT,this.__loginRoomRes);
      }
      
      private function updateList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RoomInfo = null;
         var _loc3_:DungeonListItemView = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:RoomInfo = null;
         var _loc7_:DungeonListItemView = null;
         this.randomList.clear();
         if(this._model.getRoomList().length == 0)
         {
            this.randomDungeonRooms();
         }
         else if(this._model.getRoomList().length < 6)
         {
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               if(_loc1_ < this._model.getRoomList().length)
               {
                  _loc2_ = this._model.getRoomList().list[_loc1_];
                  _loc3_ = new DungeonListItemView(_loc2_);
                  _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClick,false,0,true);
                  this._itemList.addChild(_loc3_);
                  this._itemArray.push(_loc3_);
               }
               else
               {
                  this.randomDungeonRooms();
               }
               _loc1_++;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < this._model.getRoomList().length)
            {
               _loc4_++;
               if(_loc4_ == 7)
               {
                  break;
               }
               _loc6_ = this._model.getRoomList().list[_loc1_];
               _loc7_ = new DungeonListItemView(_loc6_);
               _loc7_.addEventListener(MouseEvent.CLICK,this.__itemClick,false,0,true);
               this._itemList.addChild(_loc7_);
               this._itemArray.push(_loc7_);
               _loc5_++;
            }
         }
      }
      
      private function randomDungeonRooms() : void
      {
         var _loc2_:RoomInfo = null;
         var _loc3_:DungeonListItemView = null;
         var _loc1_:int = 0;
         while(_loc1_ < 6 - this._model.getRoomList().length)
         {
            _loc2_ = new RoomInfo();
            _loc2_.ID = this.randomRoomId();
            _loc2_.mapId = this.randomMapId();
            _loc2_.isPlaying = true;
            _loc2_.totalPlayer = 3;
            _loc2_.placeCount = 3;
            _loc3_ = new DungeonListItemView(_loc2_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClickOne,false,0,true);
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
         return Math.random() * 2;
      }
      
      private function randomMapId() : int
      {
         var _loc1_:Array = ["1","2","7","3","4","5"];
         return int(_loc1_[Math.floor(Math.random() * _loc1_.length)]);
      }
      
      private function __loginRoomRes(param1:Event) : void
      {
         this._isPermissionEnter = true;
      }
      
      private function __rivalshipBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isPermissionEnter)
         {
            return;
         }
         SocketManager.Instance.out.sendGameLogin(LookupEnumerate.DUNGEON_LIST,4);
         this._isPermissionEnter = false;
      }
      
      private function __stageClick(param1:MouseEvent) : void
      {
         if(!DisplayUtils.isTargetOrContain(param1.target as DisplayObject,this._iconBtnII) && !DisplayUtils.isTargetOrContain(param1.target as DisplayObject,this._bmpCbFb) && !(param1.target is BaseButton) && !(param1.target is ScaleBitmapImage && (param1.target as DisplayObject).parent is Scrollbar))
         {
            this._pveMapRoomListTipPanel.visible = false;
            this._pveHardLeveRoomListTipPanel.visible = false;
         }
      }
      
      private function __lookupClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controlle.showFindRoom();
      }
      
      private function __fbChange(param1:Event) : void
      {
         this.sendSift();
         if(this._pveMapRoomListTipPanel.value == 10000)
         {
            this.setTxtCbFb(LanguageMgr.GetTranslation("tank.roomlist.siftAllFb"));
         }
         else
         {
            this.setTxtCbFb(MapManager.getMapName(this._pveMapRoomListTipPanel.value));
         }
      }
      
      private function __hardLvChange(param1:Event) : void
      {
         this.sendSift();
         this.setTxtCbHardLv(this.getHardLvTxt(this._pveHardLeveRoomListTipPanel.value));
      }
      
      private function __siftReset(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._model.getRoomList().length == 0)
         {
            this.upadteItemPos();
         }
         this.resetSift();
         this.sendSift();
      }
      
      private function sendSift() : void
      {
         SocketManager.Instance.out.sendUpdateRoomList(LookupEnumerate.DUNGEON_LIST,-2,this._pveMapRoomListTipPanel.value,this._pveHardLeveRoomListTipPanel.value);
      }
      
      private function resetSift() : void
      {
         this._pveMapRoomListTipPanel.resetValue();
         this._pveHardLeveRoomListTipPanel.resetValue();
         this.setTxtCbFb(LanguageMgr.GetTranslation("tank.roomlist.siftAllFb"));
         this.setTxtCbHardLv("tank.room.difficulty.all");
      }
      
      private function setTxtCbFb(param1:String) : void
      {
         this._txtCbFb.text = param1;
         this._txtCbFb.x = this._bmpCbFb.x + (this._bmpCbFb.width - this._iconBtnII.width - this._txtCbFb.width) / 2;
      }
      
      private function setTxtCbHardLv(param1:String) : void
      {
      }
      
      private function getHardLvTxt(param1:int) : String
      {
         switch(param1)
         {
            case LookupEnumerate.DUNGEON_LIST_SIMPLE:
               return "tank.room.difficulty.simple";
            case LookupEnumerate.DUNGEON_LIST_COMMON:
               return "tank.room.difficulty.normal";
            case LookupEnumerate.DUNGEON_LIST_STRAIT:
               return "tank.room.difficulty.hard";
            case LookupEnumerate.DUNGEON_LIST_HERO:
               return "tank.room.difficulty.hero";
            default:
               return "tank.room.difficulty.all";
         }
      }
      
      private function addTipPanel() : void
      {
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_01");
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_02");
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_03");
         var _loc4_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_04");
         var _loc5_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtroomList.hardLevel_05");
         var _loc6_:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.pve.DungeonListTipPanelSizeII");
         this._pveHardLeveRoomListTipPanel = new RoomListTipPanel(_loc6_.x,_loc6_.y);
         this._pveHardLeveRoomListTipPanel.addItem(_loc5_,LookupEnumerate.DUNGEON_LIST_ALL);
         this._pveHardLeveRoomListTipPanel.addItem(_loc1_,LookupEnumerate.DUNGEON_LIST_SIMPLE);
         this._pveHardLeveRoomListTipPanel.addItem(_loc2_,LookupEnumerate.DUNGEON_LIST_COMMON);
         this._pveHardLeveRoomListTipPanel.addItem(_loc3_,LookupEnumerate.DUNGEON_LIST_STRAIT);
         this._pveHardLeveRoomListTipPanel.addItem(_loc4_,LookupEnumerate.DUNGEON_LIST_HERO);
         var _loc7_:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.pve.pveHardLeveRoomListTipPanelPos");
         this._pveHardLeveRoomListTipPanel.x = _loc7_.x;
         this._pveHardLeveRoomListTipPanel.y = _loc7_.y;
         this._pveHardLeveRoomListTipPanel.visible = false;
         addChild(this._pveHardLeveRoomListTipPanel);
         var _loc8_:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtroomList.pve.pveMapPanelPos");
         var _loc9_:Point = ComponentFactory.Instance.creatCustomObject("roomList.DungeonList.DungeonListTipPanelSizeIII");
         this._pveMapRoomListTipPanel = new RoomListMapTipPanel(_loc9_.x,_loc9_.y);
         this._pveMapRoomListTipPanel.x = _loc8_.x;
         this._pveMapRoomListTipPanel.y = _loc8_.y;
         this._pveMapRoomListTipPanel.addItem(10000);
         var _loc10_:int = 0;
         while(_loc10_ < MapManager.pveMapCount)
         {
            if(MapManager.getByOrderingDungeonInfo(_loc10_))
            {
               this._pveMapRoomListTipPanel.addItem(MapManager.getByOrderingDungeonInfo(_loc10_).ID);
            }
            _loc10_++;
         }
         var _loc11_:int = 0;
         while(_loc11_ < MapManager.pveMapCount)
         {
            if(MapManager.getByOrderingSpecialDungeonInfo(_loc11_))
            {
               this._pveMapRoomListTipPanel.addItem(MapManager.getByOrderingSpecialDungeonInfo(_loc11_).ID);
            }
            _loc11_++;
         }
         this._pveMapRoomListTipPanel.visible = false;
         addChild(this._pveMapRoomListTipPanel);
      }
      
      private function __clearRoom(param1:DictionaryEvent) : void
      {
         this._isPermissionEnter = true;
      }
      
      private function __addRoom(param1:Event) : void
      {
         this.upadteItemPos();
         this._isPermissionEnter = true;
      }
      
      private function upadteItemPos() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RoomInfo = null;
         var _loc3_:DungeonListItemView = null;
         var _loc4_:RoomInfo = null;
         var _loc5_:DungeonListItemView = null;
         var _loc6_:RoomInfo = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:RoomInfo = null;
         var _loc10_:DungeonListItemView = null;
         this._tempDataList = this.currentDataList;
         this.randomList.clear();
         this.cleanItem();
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
                     _loc3_ = new DungeonListItemView(_loc2_);
                     _loc3_.addEventListener(MouseEvent.CLICK,this.__itemClick,false,0,true);
                     this._itemList.addChild(_loc3_);
                     this._itemArray.push(_loc3_);
                  }
                  else
                  {
                     _loc4_ = new RoomInfo();
                     _loc4_.ID = this.randomRoomId();
                     _loc4_.mapId = this.randomMapId();
                     _loc4_.type = this.randomRoomtype();
                     _loc4_.isPlaying = true;
                     _loc4_.totalPlayer = 3;
                     _loc4_.placeCount = 3;
                     _loc5_ = new DungeonListItemView(_loc4_);
                     _loc5_.addEventListener(MouseEvent.CLICK,this.__itemClickOne,false,0,true);
                     this._itemList.addChild(_loc5_);
                     this._itemArray.push(_loc5_);
                  }
                  _loc1_++;
               }
            }
            else
            {
               _loc6_ = this._tempDataList[this._selectItemPos];
               _loc7_ = this.getInfosPos(this._selectItemID);
               this._tempDataList[this._selectItemPos] = this._tempDataList[_loc7_];
               this._tempDataList[_loc7_] = _loc6_;
               for each(_loc9_ in this._tempDataList)
               {
                  if(_loc9_)
                  {
                     _loc8_++;
                     if(_loc8_ == 7)
                     {
                        break;
                     }
                     _loc10_ = new DungeonListItemView(_loc9_);
                     _loc10_.addEventListener(MouseEvent.CLICK,this.__itemClick,false,0,true);
                     this._itemList.addChild(_loc10_);
                     this._itemArray.push(_loc10_);
                  }
               }
            }
         }
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
            if(!(this._itemArray[_loc2_] as DungeonListItemView))
            {
               return 0;
            }
            if((this._itemArray[_loc2_] as DungeonListItemView).id == param1)
            {
               this._selectItemPos = _loc2_;
               this._selectItemID = (this._itemArray[_loc2_] as DungeonListItemView).id;
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
      
      private function __iconBtnIIClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._pveMapRoomListTipPanel.visible = !this._pveMapRoomListTipPanel.visible;
         this._pveHardLeveRoomListTipPanel.visible = false;
      }
      
      private function __iconBtnIIIClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._pveHardLeveRoomListTipPanel.visible = !this._pveHardLeveRoomListTipPanel.visible;
         this._pveMapRoomListTipPanel.visible = false;
      }
      
      private function __updateClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendSift();
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         if(!this._isPermissionEnter)
         {
            return;
         }
         this.gotoIntoRoom((param1.currentTarget as DungeonListItemView).info);
         this.getSelectItemPos((param1.currentTarget as DungeonListItemView).id);
      }
      
      public function gotoIntoRoom(param1:RoomInfo) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendGameLogin(2,-1,param1.ID,"");
         this._isPermissionEnter = false;
      }
      
      private function __createClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._last_creat >= 2000)
         {
            this._last_creat = getTimer();
            GameInSocketOut.sendCreateRoom(PREWORD[int(Math.random() * PREWORD.length)],4,3);
         }
      }
      
      private function cleanItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemArray.length)
         {
            (this._itemArray[_loc1_] as DungeonListItemView).removeEventListener(MouseEvent.CLICK,this.__itemClick);
            (this._itemArray[_loc1_] as DungeonListItemView).dispose();
            _loc1_++;
         }
         this._itemList.disposeAllChildren();
         this._itemArray = [];
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         var _loc4_:BaseAlerFrame = null;
         var _loc2_:int = PlayerManager.Instance.Self.getBuyFatigueMoney();
         var _loc3_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc3_.removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         _loc3_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(PlayerManager.Instance.Self.DDTMoney == 0 && _loc2_ > PlayerManager.Instance.Self.Money)
            {
               _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc4_.moveEnable = false;
               _loc4_.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            }
            else
            {
               SocketManager.Instance.out.sendBuyFatigue();
            }
         }
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function cleanRoomList() : void
      {
         this.randomList.clear();
         this.randomList = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.cleanRoomList();
         this.cleanItem();
         this._itemList.dispose();
         this._itemList = null;
         this._iconBtnII.dispose();
         this._iconBtnII = null;
         if(this._movieBg)
         {
            ObjectUtils.disposeObject(this._movieBg);
         }
         this._movieBg = null;
         if(this._btnBg)
         {
            ObjectUtils.disposeObject(this._btnBg);
         }
         this._btnBg = null;
         ObjectUtils.disposeObject(this._bmpCbFb);
         this._bmpCbFb = null;
         ObjectUtils.disposeObject(this._txtCbFb);
         this._txtCbFb = null;
         if(this._Verticalline)
         {
            ObjectUtils.disposeObject(this._Verticalline);
         }
         this._Verticalline = null;
         ObjectUtils.disposeObject(this._btnSiftReset);
         this._btnSiftReset = null;
         this._nextBtn.dispose();
         this._nextBtn = null;
         this._preBtn.dispose();
         this._preBtn = null;
         this._createBtn.dispose();
         this._createBtn = null;
         this._rivalshipBtn.dispose();
         this._rivalshipBtn = null;
         this._lookUpBtn.dispose();
         this._lookUpBtn = null;
         this._lookupRoom.dispose();
         this._lookupRoom = null;
         if(this._pveHardLeveRoomListTipPanel && this._pveHardLeveRoomListTipPanel.parent)
         {
            this._pveHardLeveRoomListTipPanel.parent.removeChild(this._pveHardLeveRoomListTipPanel);
         }
         this._pveHardLeveRoomListTipPanel.dispose();
         this._pveHardLeveRoomListTipPanel = null;
         if(this._pveMapRoomListTipPanel && this._pveMapRoomListTipPanel.parent)
         {
            this._pveMapRoomListTipPanel.parent.removeChild(this._pveMapRoomListTipPanel);
         }
         this._pveMapRoomListTipPanel.dispose();
         this._pveMapRoomListTipPanel = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
