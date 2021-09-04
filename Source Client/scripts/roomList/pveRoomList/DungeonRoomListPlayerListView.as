package roomList.pveRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import roomList.pvpRoomList.RoomListPlayerListView;
   
   public class DungeonRoomListPlayerListView extends RoomListPlayerListView implements Disposeable
   {
       
      
      public function DungeonRoomListPlayerListView(param1:DictionaryData)
      {
         super(param1);
      }
      
      override protected function initbg() : void
      {
         _playerListBG = ClassUtils.CreatInstance("asset.background.roomlist.left") as MovieClip;
         PositionUtils.setPos(_playerListBG,"asset.ddtRoomlist.pvp.leftbgpos");
         _title = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.left.title");
         _characterBg = ClassUtils.CreatInstance("asset.ddtroomlist.pve.characterbg") as MovieClip;
         PositionUtils.setPos(_characterBg,"asset.ddtRoomlist.pvp.left.characterbgpos");
         _propbg = ClassUtils.CreatInstance("asset.ddtroomlist.pve.proprbg") as MovieClip;
         PositionUtils.setPos(_propbg,"asset.ddtRoomlist.pvp.left.propbgpos");
         _listbg2 = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.playerListbg");
         addChild(_listbg2);
         PositionUtils.setPos(_listbg2,"asset.ddtRoomlist.pve.listbgPos");
         _buffbgVec = new Vector.<Bitmap>(6);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtRoomlist.pvp.buffbgpos");
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            _buffbgVec[_loc2_] = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.propCellBg");
            _buffbgVec[_loc2_].x = _loc1_.x + (_buffbgVec[_loc2_].width - 1) * _loc2_;
            _buffbgVec[_loc2_].y = _loc1_.y;
            _loc2_++;
         }
      }
      
      override protected function initView() : void
      {
         super.initView();
         _level = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pve.left.levelText");
         _level.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
         addChild(_level);
         _sex = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pve.left.levelText");
         _sex.text = LanguageMgr.GetTranslation("ddt.roomlist.right.sex");
         addChild(_sex);
         PositionUtils.setPos(_level,"asset.ddtRoomlist.pve.Pos1");
         PositionUtils.setPos(_sex,"asset.ddtRoomlist.pve.Pos2");
         PositionUtils.setPos(_playerList,"asset.ddtRoomlist.pve.Pos3");
      }
   }
}
