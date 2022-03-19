// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.CharacterLoaderFactory

package ddt.view.character
{
    import ddt.data.player.PlayerInfo;

    public class CharacterLoaderFactory implements ICharacterLoaderFactory 
    {

        public static const SHOW:String = "show";
        public static const GAME:String = "game";
        public static const ROOM:String = "room";
        public static const CONSORTIA:String = "consortia";


        public function createLoader(_arg_1:PlayerInfo, _arg_2:String="show"):ICharacterLoader
        {
            var _local_3:ICharacterLoader;
            switch (_arg_2)
            {
                case SHOW:
                    _local_3 = new ShowCharacterLoader(_arg_1);
                    break;
                case GAME:
                    _local_3 = new GameCharacterLoader(_arg_1);
                    break;
                case ROOM:
                    _local_3 = new RoomCharaterLoader(_arg_1);
                    break;
            };
            if (_local_3 != null)
            {
                _local_3.setFactory(LayerFactory.instance);
            };
            return (_local_3);
        }


    }
}//package ddt.view.character

