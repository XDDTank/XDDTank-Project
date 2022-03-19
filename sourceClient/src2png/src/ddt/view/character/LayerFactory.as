// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.LayerFactory

package ddt.view.character
{
    import ddt.data.EquipType;
    import ddt.data.goods.ItemTemplateInfo;

    public class LayerFactory implements ILayerFactory 
    {

        public static const ICON:String = "icon";
        public static const SHOW:String = "show";
        public static const GAME:String = "game";
        public static const STATE:String = "state";
        public static const ROOM:String = "room";
        public static const SPECIAL_EFFECT:String = "specialEffect";
        private static var _instance:ILayerFactory;


        public static function get instance():ILayerFactory
        {
            if (_instance == null)
            {
                _instance = new (LayerFactory)();
            };
            return (_instance);
        }


        public function createLayer(_arg_1:ItemTemplateInfo, _arg_2:Boolean, _arg_3:String="", _arg_4:String="show", _arg_5:Boolean=false, _arg_6:int=1, _arg_7:String=null, _arg_8:String=""):ILayer
        {
            var _local_9:ILayer;
            switch (_arg_4)
            {
                case ICON:
                    _local_9 = new IconLayer(_arg_1, _arg_3, _arg_5, _arg_6);
                    break;
                case SHOW:
                    if (_arg_1)
                    {
                        if (_arg_1.CategoryID == EquipType.WING)
                        {
                            _local_9 = new BaseWingLayer(_arg_1);
                        }
                        else
                        {
                            _local_9 = new ShowLayer(_arg_1, _arg_3, _arg_5, _arg_6, _arg_7);
                        };
                    };
                    break;
                case GAME:
                    if (_arg_1)
                    {
                        if (_arg_1.CategoryID == EquipType.WING)
                        {
                            _local_9 = new BaseWingLayer(_arg_1, BaseWingLayer.GAME_WING);
                        }
                        else
                        {
                            _local_9 = new GameLayer(_arg_1, _arg_3, _arg_5, _arg_6, _arg_7, _arg_8);
                        };
                    };
                    break;
                case STATE:
                    _local_9 = new StateLayer(_arg_1, _arg_2, _arg_3, int(_arg_8));
                    break;
                case SPECIAL_EFFECT:
                    _local_9 = new SpecialEffectsLayer(int(_arg_8));
                    break;
                case ROOM:
                    _local_9 = new RoomLayer(_arg_1, "", false, 1, null, int(_arg_8));
                    break;
            };
            return (_local_9);
        }


    }
}//package ddt.view.character

