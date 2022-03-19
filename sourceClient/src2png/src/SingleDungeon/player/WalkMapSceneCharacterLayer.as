// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.player.WalkMapSceneCharacterLayer

package SingleDungeon.player
{
    import ddt.view.character.BaseLayer;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PathManager;

    public class WalkMapSceneCharacterLayer extends BaseLayer 
    {

        private var _direction:int;
        private var _sex:Boolean;

        public function WalkMapSceneCharacterLayer(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:int=1, _arg_4:Boolean=true)
        {
            this._direction = _arg_3;
            this._sex = _arg_4;
            super(_arg_1, _arg_2);
        }

        override protected function getUrl(_arg_1:int):String
        {
            var _local_2:String = ((this._direction == 1) ? "clothF" : ((this._direction == 2) ? "cloth" : "clothF"));
            return (((((((PathManager.SITE_MAIN + "image/world/walkcloth/1/") + ((this._sex) ? "M" : "F")) + "/") + _local_2) + "/") + String(_arg_1)) + ".png");
        }


    }
}//package SingleDungeon.player

