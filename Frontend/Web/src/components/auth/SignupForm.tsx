import { AtSign, Mail, Shield, User } from "lucide-react";
import { Link } from "react-router-dom";
import { Button } from "../ui/Button";
import { Card } from "../ui/Card";
import { Input } from "../ui/Input";
import { useAppDispatch, useAppSelector } from "../../store/hooks";
import {
  sendOtp,
  signup,
  updateFormField,
  verifyOtp,
} from "../../store/slices/authSlice";

export function SignupForm() {
  const dispatch = useAppDispatch();
  const { form, otpSent, loading, error } = useAppSelector(
    (state) => state.auth,
  );

  const handleVerifyEmail = () => {
    if (!form.email.trim()) return;
    dispatch(sendOtp(form.email.trim()));
  };

  const handleSubmit = (event: React.SubmitEvent<HTMLFormElement>) => {
    event.preventDefault();

    if (!form.otpVerified) {
      dispatch(verifyOtp({ email: form.email.trim(), otp: form.otp.trim() }));
      return;
    }

    dispatch(signup(form));
  };
  return (
    <Card>
      <div className="mb-8">
        <h2 className="text-2xl font-bold text-myspc-text">Create Account</h2>
        <p className="mt-1 text-sm text-myspc-muted">
          Let&apos;s get you all set up.
        </p>
      </div>

      <form onSubmit={handleSubmit} className="flex flex-col gap-5">
        <Input
          label="Name"
          placeholder="Preferably real name"
          icon={<User size={18} strokeWidth={1.75} />}
          value={form.displayName}
          onChange={(event) =>
            dispatch(
              updateFormField({
                field: "displayName",
                value: event.target.value,
              }),
            )
          }
          autoComplete="name"
        />

        <Input
          label="Username"
          placeholder="Choose a username"
          icon={<AtSign size={18} strokeWidth={1.75} />}
          value={form.username}
          onChange={(event) =>
            dispatch(
              updateFormField({
                field: "username",
                value: event.target.value,
              }),
            )
          }
          autoComplete="username"
        />

        <div className="flex flex-col gap-1.5">
          <label
            htmlFor="email"
            className="text-sm font-medium text-myspc-text"
          >
            Email
          </label>
          <div className="flex gap-3">
            <div className="relative min-w-0 flex-1">
              <span className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-myspc-muted">
                <Mail size={18} strokeWidth={1.75} />
              </span>
              <input
                id="email"
                type="email"
                placeholder="you@example.com"
                value={form.email}
                onChange={(event) =>
                  dispatch(
                    updateFormField({
                      field: "email",
                      value: event.target.value,
                    }),
                  )
                }
                autoComplete="email"
                className="w-full rounded-xl border border-myspc-border bg-white py-3 pl-11 pr-4 text-sm text-myspc-text placeholder:text-myspc-muted/70 focus:border-myspc-orange focus:outline-none focus:ring-2 focus:ring-myspc-orange/20"
              />
            </div>
            <Button
              type="button"
              variant="outline"
              onClick={handleVerifyEmail}
              disabled={loading || !form.email.trim()}
              className="shrink-0 px-4 py-3 text-xs sm:text-sm"
            >
              Verify Email
            </Button>
          </div>
        </div>

        <Input
          label="Enter OTP"
          placeholder="Enter 6-digit OTP"
          icon={<Shield size={18} strokeWidth={1.75} />}
          hint={
            otpSent
              ? "We've sent a 6-digit code to your email."
              : "Verify your email to receive an OTP."
          }
          value={form.otp}
          onChange={(event) =>
            dispatch(
              updateFormField({ field: "otp", value: event.target.value }),
            )
          }
          maxLength={6}
          inputMode="numeric"
          autoComplete="one-time-code"
        />

        {error && (
          <p className="rounded-lg bg-red-50 px-3 py-2 text-sm text-red-600">
            {error}
          </p>
        )}

        <Button type="submit" fullWidth disabled={loading}>
          {loading && !otpSent ? "Sending OTP" : loading && !form.otpVerified 
            ? "Verifying OTP..."
            : loading && form.otpVerified
              ? "Creating Account..."
              : form.otpVerified
                ? "Create Account"
                : "Verify OTP"}
        </Button>
      </form>

      <p className="mt-6 text-center text-sm text-myspc-muted">
        Already have an account?{" "}
        <Link
          to="/login"
          className="font-semibold text-myspc-orange hover:text-myspc-orange-dark"
        >
          Login
        </Link>
      </p>
    </Card>
  );
}
