using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AimsharpWow.API; //needed to access Aimsharp API

namespace AimsharpWow.Modules
{
    public class SpellQueue : Plugin
    {

        public override void Initialize()
        {

            Aimsharp.PrintMessage("Spell Queue Plugin");
            Aimsharp.PrintMessage("Use this macro to manually queue spells: /xxxxx queue spellname");

            
        }

        public override bool CombatTick()
        {
            
            bool IAmChanneling = Aimsharp.IsChanneling("player");
            int GCD = Aimsharp.GCD();
            bool LineOfSighted = Aimsharp.LineOfSighted();

            bool BuffGhostWolfUp = Aimsharp.HasBuff("Ghost Wolf");

            string QueuedSpell = Aimsharp.GetSpellQueue();

            Aimsharp.PrintMessage("Queued spell is: " + QueuedSpell);

            if (QueuedSpell == "Thunderstorm")
            {
                if (Aimsharp.CanCast("Thunderstorm","player"))
                {
                    Aimsharp.Cast("ThunderstormC");
                    return true;
                }
            }
            else if (QueuedSpell == "Earthquake")
            {
                if (Aimsharp.CanCast("Earthquake","player"))
                {
                    Aimsharp.Cast("EarthquakeC");
                    return true;
                }
            }
            else if (QueuedSpell == "Earthbind Totem")
            {
                if (Aimsharp.CanCast("Earthbind Totem", "player"))
                {
                    Aimsharp.Cast("EB");
                    return true;
                }
            }
            else if (QueuedSpell == "Capacitor Totem")
            {
                if (Aimsharp.CanCast("Capacitor Totem", "player"))
                {
                    Aimsharp.Cast("Cap");
                    return true;
                }
            }
            else if (QueuedSpell == "Totemic Projection")
            {
                if (Aimsharp.CanCast("Static Field Totem", "player"))
                {
                    Aimsharp.Cast("SFT");
                    return true;
                }
                if (GCD <= 500)
                {
                    if (Aimsharp.CanCast("Totemic Projection", "player"))
                    {
                        Aimsharp.Cast("TP");
                        return true;
                    }
                }
                return true;
            }
            else if (Aimsharp.CanCast(QueuedSpell,"player"))
            {
                Aimsharp.Cast(QueuedSpell);
                return true;
            }

            return false;
        }

        public override bool OutOfCombatTick()
        {
            return CombatTick();

        }
    }
}