package roomList.pveRoomList
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import room.model.RoomInfo;
   
   public class DungeonListItemView extends Sprite implements Disposeable
   {
      
      public static const NAN_MAP:int = 10000;
       
      
      private var _info:RoomInfo;
      
      private var _mode:ScaleFrameImage;
      
      private var _itemBg:ScaleFrameImage;
      
      private var _lock:Bitmap;
      
      private var _nameText:FilterFrameText;
      
      private var _placeCountText:FilterFrameText;
      
      private var _hard:FilterFrameText;
      
      private var _simpMapLoader:DisplayLoader;
      
      private var _loader:DisplayLoader;
      
      private var _mapShowContainer:Sprite;
      
      private var _mapShow:Bitmap;
      
      private var _simpMapShow:Bitmap;
      
      private var _mask:Sprite;
      
      private var _roomIdVec:Vector.<Bitmap>;
      
      private var _hardLevel:Array;
      
      public function DungeonListItemView(param1:RoomInfo = null)
      {
         this._hardLevel = ["tank.room.difficulty.simple","tank.room.difficulty.normal","tank.room.difficulty.hard","tank.room.difficulty.hero","tank.room.difficulty.none"];
         this._info = param1;
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Rectangle = null;
         this.buttonMode = true;
         this._mapShowContainer = new Sprite();
         this._mapShowContainer.graphics.beginFill(0,0);
         this._mapShowContainer.graphics.drawRect(30,0,120,69);
         this._mapShowContainer.graphics.endFill();
         addChild(this._mapShowContainer);
         this._itemBg = ComponentFactory.Instance.creat("asset.ddtroomList.pve.DungeonListItembg");
         this._itemBg.setFrame(1);
         addChild(this._itemBg);
         this._hard = UICreatShortcut.creatTextAndAdd("asset.ddtDungeonList.pve.itemHardTextStyle","XXOO",this);
         this._nameText = ComponentFactory.Instance.creat("asset.ddtroomList.DungeonList.nameText");
         this._placeCountText = ComponentFactory.Instance.creat("asset.ddtroomList.DungeonList.placeCountText");
         addChild(this._placeCountText);
         this._lock = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.item.lock");
         PositionUtils.setPos(this._lock,"asset.ddtdungeonList.lockPos");
         this._lock.visible = false;
         addChild(this._lock);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("asset.ddtdungeonList.maskRectangle");
         this._mask = new Sprite();
         this._mask.visible = false;
         this._mask.graphics.beginFill(0,0);
         this._mask.graphics.drawRoundRect(0,0,_loc1_.width,_loc1_.height,_loc1_.y);
         this._mask.graphics.endFill();
         PositionUtils.setPos(this._mask,"asset.ddtroomListItem.maskPos");
         addChild(this._mask);
         this.update();
      }
      
      public function get info() : RoomInfo
      {
         return this._info;
      }
      
      public function set info(param1:RoomInfo) : void
      {
         this._info = param1;
         this.update();
      }
      
      public function get id() : int
      {
         return this._info.ID;
      }
      
      private function update() : void
      {
         this.updateRoomId();
         this._lock.visible = this._info.IsLocked;
         this._nameText.text = this._info.Name;
         if(this._info.mapId == 0 || this._info.mapId == 10000)
         {
            this._hard.visible = false;
         }
         else
         {
            this._hard.visible = true;
            this._hard.text = "(" + LanguageMgr.GetTranslation(this._hardLevel[this._info.hardLevel]) + ")";
         }
         var _loc1_:String = this._info.maxViewerCnt == 0 ? "-" : String(this._info.viewerCnt);
         this._placeCountText.text = String(this._info.totalPlayer) + "/" + String(this._info.placeCount);
         if(this._info.isPlaying || this._info.isOpenBoss)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._itemBg.setFrame(1);
            this._nameText.setFrame(2);
            this._hard.setFrame(2);
            this._placeCountText.setFrame(2);
         }
         else
         {
            filters = null;
            this._itemBg.setFrame(1);
            this._nameText.setFrame(1);
            this._hard.setFrame(1);
            this._placeCountText.setFrame(1);
         }
         this.loadIcon();
      }
      
      private function updateRoomId() : void
      {
         var _loc1_:String = this._info.ID.toString();
         this._roomIdVec = new Vector.<Bitmap>(_loc1_.length);
         var _loc2_:Point = PositionUtils.creatPoint("asset.ddtroomList.idPos" + _loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            this._roomIdVec[_loc3_] = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.roomNumber" + _loc1_.charAt(_loc3_));
            this._roomIdVec[_loc3_].x = _loc2_.x + (this._roomIdVec[_loc3_].width - 2) * _loc3_;
            this._roomIdVec[_loc3_].y = _loc2_.y;
            addChild(this._roomIdVec[_loc3_]);
            _loc3_++;
         }
      }
      
      private function loadIcon() : void
      {
         var _loc1_:int = this._info.mapId == 0 ? int(NAN_MAP) : int(this._info.mapId);
         if(this._mapShow)
         {
            ObjectUtils.disposeObject(this._mapShow);
            this._mapShow = null;
         }
         this._mapShow = ComponentFactory.Instance.creatBitmap(_loc1_.toString() + "_samll_map.png");
         this._mapShow.smoothing = true;
         if(this._info.isPlaying)
         {
            this._mapShow.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._mapShow.filters = null;
         }
         PositionUtils.setPos(this._mapShow,"asset.ddtdungeonList.MapShowPos");
         if(!this._mapShowContainer)
         {
            this._mapShowContainer = new Sprite();
         }
         this._mapShowContainer.addChild(this._mapShow);
         this._mapShowContainer.mask = this._mask;
         if(this._simpMapLoader)
         {
            this._simpMapLoader.removeEventListener(LoaderEvent.COMPLETE,this.__showSimpMap);
         }
         this._simpMapLoader = LoadResourceManager.instance.createLoader(PathManager.solveMapIconPath(_loc1_,0),BaseLoader.BITMAP_LOADER);
         this._simpMapLoader.addEventListener(LoaderEvent.COMPLETE,this.__showSimpMap);
         LoadResourceManager.instance.startLoad(this._simpMapLoader);
      }
      
      private function __showMap(param1:LoaderEvent) : void
      {
         if(param1.loader.isSuccess)
         {
            ObjectUtils.disposeAllChildren(this._mapShowContainer);
            param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__showMap);
            if(this._mapShow)
            {
               ObjectUtils.disposeObject(this._mapShow);
            }
            this._mapShow = null;
         }
      }
      
      private function __showSimpMap(param1:LoaderEvent) : void
      {
         if(param1.loader.isSuccess)
         {
            param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__showSimpMap);
            if(this._simpMapShow)
            {
               ObjectUtils.disposeObject(this._simpMapShow);
               this._simpMapShow = null;
            }
            this._simpMapShow = param1.loader.content as Bitmap;
            if(this._info.isPlaying)
            {
               this._simpMapShow.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
               this._simpMapShow.filters = null;
            }
            PositionUtils.setPos(this._simpMapShow,"asset.ddtdungeonList.simpMapPos");
            addChild(this._simpMapShow);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__showMap);
            this._loader = null;
         }
         if(this._simpMapLoader)
         {
            this._simpMapLoader.removeEventListener(LoaderEvent.COMPLETE,this.__showSimpMap);
            this._simpMapLoader = null;
         }
         if(this._simpMapShow)
         {
            ObjectUtils.disposeObject(this._simpMapShow);
            this._simpMapShow = null;
         }
         if(this._mapShowContainer && this._mapShowContainer.parent)
         {
            ObjectUtils.disposeAllChildren(this._mapShowContainer);
            this._mapShowContainer.parent.removeChild(this._mapShowContainer);
            this._mapShowContainer = null;
         }
         if(this._mask && this._mask.parent)
         {
            ObjectUtils.disposeAllChildren(this._mask);
            this._mask.parent.removeChild(this._mask);
            this._mask = null;
         }
         if(this._mapShow)
         {
            ObjectUtils.disposeObject(this._mapShow);
            this._mapShow = null;
         }
         if(this._hard)
         {
            ObjectUtils.disposeObject(this._hard);
            this._hard = null;
         }
         if(this._roomIdVec)
         {
            _loc1_ = 0;
            while(_loc1_ < this._roomIdVec.length)
            {
               ObjectUtils.disposeObject(this._roomIdVec[_loc1_]);
               this._roomIdVec[_loc1_] = null;
               _loc1_++;
            }
            this._roomIdVec = null;
         }
         ObjectUtils.disposeObject(this._lock);
         this._lock = null;
         this._itemBg.dispose();
         this._nameText.dispose();
         this._placeCountText.dispose();
         this._itemBg = null;
         this._nameText = null;
         this._placeCountText = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
