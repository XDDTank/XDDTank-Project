// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.CharactoryFactory

package ddt.view.character
{
    import ddt.data.player.PlayerInfo;

    public class CharactoryFactory 
    {

        public static const SHOW:String = "show";
        public static const GAME:String = "game";
        public static const CONSORTIA:String = "consortia";
        public static const ROOM:String = "room";
        private static var _characterloaderfactory:ICharacterLoaderFactory = new CharacterLoaderFactory();


        public static function createCharacter(_arg_1:PlayerInfo, _arg_2:String="show", _arg_3:Boolean=false):ICharacter
        {
            var _local_4:ICharacter;
            switch (_arg_2)
            {
                case SHOW:
                    _local_4 = new ShowCharacter(_arg_1, true, true, _arg_3);
                    break;
                case GAME:
                    _local_4 = new GameCharacter(_arg_1);
                    break;
                case ROOM:
                    _local_4 = new RoomCharacter(_arg_1, true);
            };
            if (_local_4 != null)
            {
                _local_4.setFactory(_characterloaderfactory);
            };
            return (_local_4);
        }


    }
}//package ddt.view.character

