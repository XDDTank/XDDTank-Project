// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.effects.AttackEffectIcon

package game.view.effects
{
    import game.objects.MirariType;

    public class AttackEffectIcon extends BaseMirariEffectIcon 
    {

        public function AttackEffectIcon()
        {
            _iconClass = "asset.game.buff.attack";
            super();
        }

        override public function get mirariType():int
        {
            return (MirariType.Attack);
        }


    }
}//package game.view.effects

