// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.player.WorldBossSceneCharacterLayer

package worldboss.player
{
    import ddt.view.character.BaseLayer;
    import ddt.data.goods.ItemTemplateInfo;
    import worldboss.WorldBossManager;

    public class WorldBossSceneCharacterLayer extends BaseLayer 
    {

        private var _direction:int;
        private var _sex:Boolean;

        public function WorldBossSceneCharacterLayer(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:int=1, _arg_4:Boolean=true)
        {
            this._direction = _arg_3;
            this._sex = _arg_4;
            super(_arg_1, _arg_2);
        }

        override protected function getUrl(_arg_1:int):String
        {
            var _local_2:String = ((this._direction == 1) ? "clothF" : ((this._direction == 2) ? "cloth" : "clothF"));
            return (((((((WorldBossManager.Instance.getWorldbossResource() + "/cloth/") + ((this._sex) ? "M" : "F")) + "/") + _local_2) + "/") + String(_arg_1)) + ".png");
        }


    }
}//package worldboss.player

