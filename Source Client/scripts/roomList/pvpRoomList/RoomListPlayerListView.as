package roomList.pvpRoomList
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class RoomListPlayerListView extends Sprite implements Disposeable
   {
       
      
      private var _selfInfo:SelfInfo;
      
      protected var _playerListBG:MovieClip;
      
      protected var _title:Bitmap;
      
      protected var _characterBg:MovieClip;
      
      protected var _propbg:MovieClip;
      
      protected var _listbg2:Bitmap;
      
      private var _iconContainer:VBox;
      
      protected var _level:FilterFrameText;
      
      protected var _sex:FilterFrameText;
      
      protected var _playerList:ListPanel;
      
      private var _data:DictionaryData;
      
      private var _currentItem:RoomListPlayerItem;
      
      protected var _buffbgVec:Vector.<Bitmap>;
      
      private var _vipName:GradientText;
      
      public function RoomListPlayerListView(param1:DictionaryData)
      {
         this._data = param1;
         super();
         this._selfInfo = PlayerManager.Instance.Self;
         this.initbg();
         this.initView();
         this.initEvent();
      }
      
      public function set type(param1:int) : void
      {
      }
      
      protected function initbg() : void
      {
         var _loc1_:Point = null;
         var _loc2_:int = 0;
         this._playerListBG = ClassUtils.CreatInstance("asset.background.roomlist.left") as MovieClip;
         PositionUtils.setPos(this._playerListBG,"asset.ddtRoomlist.pvp.leftbgpos");
         this._title = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.left.title");
         this._characterBg = ClassUtils.CreatInstance("asset.ddtroomlist.characterbg") as MovieClip;
         PositionUtils.setPos(this._characterBg,"asset.ddtRoomlist.pvp.left.characterbgpos");
         this._propbg = ClassUtils.CreatInstance("asset.ddtroomlist.proprbg") as MovieClip;
         PositionUtils.setPos(this._propbg,"asset.ddtRoomlist.pvp.left.propbgpos");
         this._listbg2 = ComponentFactory.Instance.creatBitmap("asset.ddrroomlist.PlayerBg");
         addChild(this._listbg2);
         this._buffbgVec = new Vector.<Bitmap>(6);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("asset.ddtRoomlist.pvp.buffbgpos");
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            this._buffbgVec[_loc2_] = ComponentFactory.Instance.creatBitmap("asset.core.buff.buffTiledBg");
            this._buffbgVec[_loc2_].x = _loc1_.x + (this._buffbgVec[_loc2_].width - 1) * _loc2_;
            this._buffbgVec[_loc2_].y = _loc1_.y;
            _loc2_++;
         }
         this._level = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.levelText");
         this._level.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
         addChild(this._level);
         this._sex = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.sexText");
         this._sex.text = LanguageMgr.GetTranslation("ddt.roomlist.right.sex");
         addChild(this._sex);
      }
      
      protected function initView() : void
      {
         this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.iconContainer");
         addChild(this._iconContainer);
         this._playerList = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pvp.left.playerlistII");
         addChild(this._playerList);
         this._playerList.list.updateListView();
         this._playerList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
      }
      
      private function initEvent() : void
      {
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._data.addEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateEverything);
      }
      
      private function __updateEverything(param1:PlayerPropertyEvent) : void
      {
      }
      
      private function __updatePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerInfo = param1.data as PlayerInfo;
         this._playerList.vectorListModel.remove(_loc2_);
         this._playerList.vectorListModel.insertElementAt(_loc2_,this.getInsertIndex(_loc2_));
         this._playerList.list.updateListView();
         this.upSelfItem();
      }
      
      private function __addPlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerInfo = param1.data as PlayerInfo;
         this._playerList.vectorListModel.insertElementAt(_loc2_,this.getInsertIndex(_loc2_));
         this.upSelfItem();
      }
      
      private function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerInfo = param1.data as PlayerInfo;
         this._playerList.vectorListModel.remove(_loc2_);
         this.upSelfItem();
      }
      
      private function upSelfItem() : void
      {
         var _loc1_:PlayerInfo = this._data[PlayerManager.Instance.Self.ID];
         var _loc2_:int = this._playerList.vectorListModel.indexOf(_loc1_);
         if(_loc2_ == -1 || _loc2_ == 0)
         {
            return;
         }
         this._playerList.vectorListModel.removeAt(_loc2_);
         this._playerList.vectorListModel.append(_loc1_,0);
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._currentItem)
         {
            this._currentItem = param1.cell as RoomListPlayerItem;
            this._currentItem.setListCellStatus(this._playerList.list,true,param1.index);
         }
         if(this._currentItem != param1.cell as RoomListPlayerItem)
         {
            this._currentItem.setListCellStatus(this._playerList.list,false,param1.index);
            this._currentItem = param1.cell as RoomListPlayerItem;
            this._currentItem.setListCellStatus(this._playerList.list,true,param1.index);
         }
      }
      
      private function getInsertIndex(param1:PlayerInfo) : int
      {
         var _loc4_:PlayerInfo = null;
         var _loc2_:int = 0;
         var _loc3_:Array = this._playerList.vectorListModel.elements;
         if(_loc3_.length == 0)
         {
            return 0;
         }
         var _loc5_:int = _loc3_.length - 1;
         while(_loc5_ >= 0)
         {
            _loc4_ = _loc3_[_loc5_] as PlayerInfo;
            if(!(param1.IsVIP && !_loc4_.IsVIP))
            {
               if(!param1.IsVIP && _loc4_.IsVIP)
               {
                  return _loc5_ + 1;
               }
               if(param1.IsVIP == _loc4_.IsVIP)
               {
                  if(param1.Grade <= _loc4_.Grade)
                  {
                     return _loc5_ + 1;
                  }
                  _loc2_ = _loc5_ - 1;
               }
            }
            _loc5_--;
         }
         return _loc2_ < 0 ? int(0) : int(_loc2_);
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._data.removeEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateEverything);
         this._playerList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         ObjectUtils.disposeObject(this._playerListBG);
         this._playerListBG = null;
         if(this._listbg2)
         {
            ObjectUtils.disposeObject(this._listbg2);
         }
         this._listbg2 = null;
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(this._characterBg)
         {
            ObjectUtils.disposeObject(this._characterBg);
         }
         this._characterBg = null;
         if(this._propbg)
         {
            ObjectUtils.disposeObject(this._propbg);
         }
         this._propbg = null;
         if(this._level)
         {
            ObjectUtils.disposeObject(this._level);
         }
         this._level = null;
         if(this._sex)
         {
            ObjectUtils.disposeObject(this._sex);
         }
         this._sex = null;
         if(this._buffbgVec)
         {
            _loc1_ = 0;
            while(_loc1_ < this._buffbgVec.length)
            {
               ObjectUtils.disposeObject(this._buffbgVec[_loc1_]);
               this._buffbgVec[_loc1_] = null;
               _loc1_++;
            }
            this._buffbgVec = null;
         }
         this._playerList.vectorListModel.clear();
         this._playerList.dispose();
         this._playerList = null;
         this._data = null;
         if(this._currentItem)
         {
            this._currentItem.dispose();
         }
         this._currentItem = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
