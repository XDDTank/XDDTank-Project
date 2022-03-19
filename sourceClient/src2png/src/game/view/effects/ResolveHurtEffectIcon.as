// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.ResolveHurtEffectIcon

package game.view.effects
{
    import game.animations.IAnimate;
    import game.objects.MirariType;

    public class ResolveHurtEffectIcon extends BaseMirariEffectIcon 
    {

        private var _skillAnimation:IAnimate;

        public function ResolveHurtEffectIcon()
        {
            _iconClass = "asset.game.resolveHurtAsset";
            super();
        }

        override public function get mirariType():int
        {
            return (MirariType.ResolveHurt);
        }


    }
}//package game.view.effects

