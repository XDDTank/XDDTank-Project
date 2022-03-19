// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.sceneCharacter.SceneCharacterActionItem

package ddt.view.sceneCharacter
{
    public class SceneCharacterActionItem 
    {

        public var type:String;
        public var frames:Array;
        public var repeat:Boolean;

        public function SceneCharacterActionItem(_arg_1:String, _arg_2:Array, _arg_3:Boolean)
        {
            this.type = _arg_1;
            this.frames = _arg_2;
            this.repeat = _arg_3;
        }

        public function dispose():void
        {
            while (((this.frames) && (this.frames.length > 0)))
            {
                this.frames.shift();
            };
            this.frames = null;
        }


    }
}//package ddt.view.sceneCharacter

