// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.pveRoomList.DungeonRoomListPlayerListView

package roomList.pveRoomList
{
    import roomList.pvpRoomList.RoomListPlayerListView;
    import com.pickgliss.ui.core.Disposeable;
    import road7th.data.DictionaryData;
    import com.pickgliss.utils.ClassUtils;
    import flash.display.MovieClip;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import ddt.manager.LanguageMgr;
    import __AS3__.vec.*;

    public class DungeonRoomListPlayerListView extends RoomListPlayerListView implements Disposeable 
    {

        public function DungeonRoomListPlayerListView(_arg_1:DictionaryData)
        {
            super(_arg_1);
        }

        override protected function initbg():void
        {
            _playerListBG = (ClassUtils.CreatInstance("asset.background.roomlist.left") as MovieClip);
            PositionUtils.setPos(_playerListBG, "asset.ddtRoomlist.pvp.leftbgpos");
            _title = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.left.title");
            _characterBg = (ClassUtils.CreatInstance("asset.ddtroomlist.pve.characterbg") as MovieClip);
            PositionUtils.setPos(_characterBg, "asset.ddtRoomlist.pvp.left.characterbgpos");
            _propbg = (ClassUtils.CreatInstance("asset.ddtroomlist.pve.proprbg") as MovieClip);
            PositionUtils.setPos(_propbg, "asset.ddtRoomlist.pvp.left.propbgpos");
            _listbg2 = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.playerListbg");
            addChild(_listbg2);
            PositionUtils.setPos(_listbg2, "asset.ddtRoomlist.pve.listbgPos");
            _buffbgVec = new Vector.<Bitmap>(6);
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("asset.ddtRoomlist.pvp.buffbgpos");
            var _local_2:int;
            while (_local_2 < 6)
            {
                _buffbgVec[_local_2] = ComponentFactory.Instance.creatBitmap("asset.ddtroomlist.pve.propCellBg");
                _buffbgVec[_local_2].x = (_local_1.x + ((_buffbgVec[_local_2].width - 1) * _local_2));
                _buffbgVec[_local_2].y = _local_1.y;
                _local_2++;
            };
        }

        override protected function initView():void
        {
            super.initView();
            _level = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pve.left.levelText");
            _level.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
            addChild(_level);
            _sex = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.pve.left.levelText");
            _sex.text = LanguageMgr.GetTranslation("ddt.roomlist.right.sex");
            addChild(_sex);
            PositionUtils.setPos(_level, "asset.ddtRoomlist.pve.Pos1");
            PositionUtils.setPos(_sex, "asset.ddtRoomlist.pve.Pos2");
            PositionUtils.setPos(_playerList, "asset.ddtRoomlist.pve.Pos3");
        }


    }
}//package roomList.pveRoomList

