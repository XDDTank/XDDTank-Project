// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.OpitionEnum

package ddt.data
{
    import ddt.manager.PlayerManager;

    public class OpitionEnum 
    {

        public static const RefusedBeFriend:int = 1;
        public static const RefusedPrivateChat:int = 4;
        public static const IsSetGuide:int = 32;
        public static const IsShowPetSprite:int = 64;


        public static function setOpitionState(_arg_1:Boolean, _arg_2:int):int
        {
            var _local_3:int = PlayerManager.Instance.Self.OptionOnOff;
            if (_arg_1)
            {
                _local_3 = (_local_3 | _arg_2);
            }
            else
            {
                _local_3 = ((~(_arg_2)) & _local_3);
            };
            return (_local_3);
        }


    }
}//package ddt.data

