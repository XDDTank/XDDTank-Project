// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterLayer

package ddt.view.sceneCharacter
{
    import ddt.view.character.BaseLayer;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PathManager;

    public class SceneCharacterLayer extends BaseLayer 
    {

        protected var _direction:int;
        protected var _sceneCharacterLoaderPath:String;
        protected var _sex:Boolean;

        public function SceneCharacterLayer(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:int=1, _arg_4:Boolean=true, _arg_5:String="")
        {
            this._direction = _arg_3;
            this._sceneCharacterLoaderPath = _arg_5;
            this._sex = ((_arg_1.NeedSex == 1) ? true : false);
            super(_arg_1, _arg_2);
        }

        override protected function getUrl(_arg_1:int):String
        {
            return (PathManager.solveSceneCharacterLoaderPath(_info.CategoryID, _info.Pic, this._sex, (_info.NeedSex == 1), String(_arg_1), this._direction, this._sceneCharacterLoaderPath));
        }


    }
}//package ddt.view.sceneCharacter

