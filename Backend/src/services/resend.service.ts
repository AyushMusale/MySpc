import { Resend } from "resend";

const resend = new Resend(process.env.RESEND_API_KEY);

export const sendOtpEmail = async (email: string, otp: string) => {
  const { data, error } = await resend.emails.send({
    from: process.env.RESEND_FROM_EMAIL as string, // e.g. "Acme <noreply@yourdomain.com>"
    to: email,
    subject: "Your verification code",
    html: `
      <div style="font-family: sans-serif; text-align: center;">
        <h2>Your OTP Code</h2>
        <p style="font-size: 32px; font-weight: bold; letter-spacing: 6px;">${otp}</p>
        <p>This code expires in 5 minutes.</p>
      </div>
    `,
  });

  if (error) {
    throw new Error(`Failed to send OTP email: ${error.message}`);
  }

  return data;
};